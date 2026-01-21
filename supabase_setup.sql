
-- ... (existing tables: profiles, wallet_balances, transactions, security_vault, notifications, webhook_logs, system_gateways)

-- 8. Tabla de Tarjetas Bancarias (Vault de Pagos)
create table if not exists public.bank_cards (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade,
  holder_name text not null,
  last4 text not null,
  brand text not null, -- 'VISA', 'MASTERCARD', 'MIR'
  exp_month text not null,
  exp_year text not null,
  color text not null,
  secure_token text, -- Tokenización simulada
  created_at timestamp with time zone default now()
);

alter table public.bank_cards enable row level security;

create policy "Usuarios pueden gestionar sus propias tarjetas"
  on bank_cards for all
  using ( auth.uid() = user_id );

-- Insertar tarjetas iniciales de demo para el usuario si no existen (opcional)
