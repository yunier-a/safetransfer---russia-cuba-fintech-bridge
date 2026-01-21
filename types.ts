
export interface Message {
  id: string;
  type: 'bot' | 'user';
  text: string;
  time: string;
  groundingLinks?: { title: string; uri: string }[];
}

export interface Wallet {
  id: string;
  name: string;
  symbol: string;
  amount: string;
  fiatValue: string;
  color: string;
  icon: string;
}

export interface AppNotification {
  id: string;
  title: string;
  message: string;
  type: 'DEPOSIT' | 'TRANSFER' | 'RECHARGE' | 'SYSTEM';
  status: 'INFO' | 'SUCCESS' | 'WARNING';
  timestamp: string;
  read: boolean;
}

export interface BankCard {
  id: string;
  holder_name: string;
  last4: string;
  brand: string; // 'VISA', 'MASTERCARD', 'MIR'
  exp_month: string;
  exp_year: string;
  color: string;
}

export interface Transaction {
  id: string;
  recipient: string;
  amount: string;
  currency: string;
  date: string;
  status: 'SUCCESS' | 'PENDING' | 'FAILED';
  /* The type of transaction (e.g., 'Remittance', 'Swap', 'Recharge') */
  type: string;
  memo?: string;
  fee?: string;
  account?: string;
  network?: string;
  hash?: string;
  created_at?: string;
  node_id?: string;
}

export interface Reward {
  id: string;
  type: string;
  title: string;
  expiry: string;
  img: string;
}
