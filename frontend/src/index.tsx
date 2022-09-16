import {Suspense, StrictMode} from 'react';
import ReactDOM from 'react-dom/client';
import Home from './views/Home';
import reportWebVitals from './reportWebVitals';
import {Route, Routes} from 'react-router';
import {HashRouter} from 'react-router-dom';
import './index.css';
import Withdraw from './views/Withdraw';
import Dashboard from './views/Dashboard';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <StrictMode>
    <Suspense>
      <HashRouter>
        <Routes>
          <Route path="/" element={<Home />}/>
          <Route path='withdraw' element={<Withdraw/>} />
          <Route path='dashboard' element={<Dashboard/>} />
        </Routes>
      </HashRouter>
    </Suspense>
  </StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();