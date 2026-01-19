
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
}

export interface Reward {
  id: string;
  type: string;
  title: string;
  expiry: string;
  img: string;
}
