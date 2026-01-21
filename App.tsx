
import React from 'react';
import { HashRouter, Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import Activity from './pages/Activity';
import Exchange from './pages/Exchange';
import Profile from './pages/Profile';
import SendMoney from './pages/SendMoney';
import ConfirmTransfer from './pages/ConfirmTransfer';
import Success from './pages/Success';
import BotChat from './pages/BotChat';
import Vault from './pages/Vault';
import SafeZones from './pages/SafeZones';
import Rewards from './pages/Rewards';
import DepositCrypto from './pages/DepositCrypto';
import Wallets from './pages/Wallets';
import WalletDetail from './pages/WalletDetail';
import Recharge from './pages/Recharge';
import Beneficiaries from './pages/Beneficiaries';
import AdminNode from './pages/AdminNode';
import GatewayCheckout from './pages/GatewayCheckout';
import Notifications from './pages/Notifications';

const App: React.FC = () => {
  return (
    <HashRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/activity" element={<Activity />} />
        <Route path="/exchange" element={<Exchange />} />
        <Route path="/profile" element={<Profile />} />
        <Route path="/send" element={<SendMoney />} />
        <Route path="/confirm" element={<ConfirmTransfer />} />
        <Route path="/success" element={<Success />} />
        <Route path="/bot" element={<BotChat />} />
        <Route path="/vault" element={<Vault />} />
        <Route path="/safe-zones" element={<SafeZones />} />
        <Route path="/rewards" element={<Rewards />} />
        <Route path="/deposit" element={<DepositCrypto />} />
        <Route path="/wallets" element={<Wallets />} />
        <Route path="/wallets/:id" element={<WalletDetail />} />
        <Route path="/recharge" element={<Recharge />} />
        <Route path="/beneficiaries" element={<Beneficiaries />} />
        <Route path="/admin-node" element={<AdminNode />} />
        <Route path="/gateway-checkout" element={<GatewayCheckout />} />
        <Route path="/notifications" element={<Notifications />} />
      </Routes>
    </HashRouter>
  );
};

export default App;
