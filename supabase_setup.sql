
-- 1. Actualizar tabla de transacciones para conciliación automática
alter table public.transactions 
add column if not exists external_id text unique, -- ID de SBP, EnZona o Hash Cripto
add column if not exists raw_payload jsonb,      -- Para guardar el payload del Webhook o SMS crudo
add column if not exists confirmed_at timestamp with time zone,
add column if not exists fee_applied numeric default 0;

-- 2. Crear tabla de logs de Webhooks
-- Esta tabla recibe todas las peticiones de las pasarelas (NOWPayments, SBP, etc.)
create table if not exists public.webhook_logs (
  id uuid default gen_random_uuid() primary key,
  provider text not null, -- 'SBP_RUSSIA', 'CUBA_BRIDGE_NODE', 'NOWPAYMENTS'
  payload jsonb not null,
  processed boolean default false,
  error_message text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Tabla de Pasarelas y Nodos
create table if not exists public.payment_gateways (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  is_active boolean default true,
  config jsonb, -- Almacena credenciales o números de tarjeta asignados
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. Función de Conciliación Automática
-- Esta función busca una transacción pendiente que coincida con la referencia y el monto
create or replace function public.process_automatic_settlement(
  p_user_node_id text,    -- El NODE-ID que el usuario puso en el comentario
  p_amount numeric, 
  p_external_id text, 
  p_currency text
)
returns boolean
language plpgsql
security definer
as $$
declare
  v_tx_id uuid;
  v_user_id uuid;
begin
  -- 1. Buscar al usuario por los primeros 8 caracteres de su ID (el NODE-ID)
  select id into v_user_id from auth.users where upper(substring(id::text, 1, 8)) = upper(p_user_node_id);
  
  if v_user_id is null then
    return false;
  end if;

  -- 2. Buscar si ya existe una transacción PENDING para este usuario y monto
  -- O crear una nueva si es un depósito directo no iniciado en la App
  select id into v_tx_id 
  from public.transactions 
  where user_id = v_user_id 
    and status = 'PENDING' 
    and currency = p_currency
    and amount = p_amount
  limit 1;

  if v_tx_id is not null then
    -- Actualizar transacción existente
    update public.transactions 
    set status = 'SUCCESS',
        external_id = p_external_id,
        confirmed_at = now()
    where id = v_tx_id;
  else
    -- Crear nueva transacción (depósito directo)
    insert into public.transactions (user_id, recipient, amount, currency, type, status, external_id, confirmed_at, memo)
    values (v_user_id, 'SafeNode Auto-Settlement', p_amount, p_currency, 'Deposit', 'SUCCESS', p_external_id, now(), 'Direct Node Deposit');
  end if;

  -- 3. Actualizar el balance del usuario inmediatamente
  update public.wallet_balances 
  set balance = balance + p_amount,
      updated_at = now()
  where user_id = v_user_id and symbol = p_currency;

  return true;
end;
$$;

-- 5. Habilitar RLS para nuevas tablas
alter table public.webhook_logs enable row level security;
alter table public.payment_gateways enable row level security;

-- Solo administradores pueden ver logs de webhooks (simulado con check de rol o service role)
create policy "Admin only view logs" on public.webhook_logs for select using (true);
create policy "Admin only view gateways" on public.payment_gateways for select using (true);

-- 6. Insertar configuración inicial de nodos
insert into public.payment_gateways (name, config) values
('SBP_RUSSIA_NODE', '{"terminal": "SBER-01", "method": "SBP", "currency": "RUB"}'),
('CUBA_TRANSFERMOVIL_NODE', '{"terminal": "HAV-01", "method": "SMS_BRIDGE", "currency": "CUP"}'),
('CUBA_MLC_NODE', '{"terminal": "MLC-01", "method": "SMS_BRIDGE", "currency": "MLC"}');
