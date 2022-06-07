import React from 'react';
import { useState, useEffect } from "react";
import ReactDOM from 'react-dom/client';
import { useForm, SubmitHandler } from "react-hook-form";
import './index.css';
import Guess from './Guess';
import reportWebVitals from './reportWebVitals';
import { type } from '@testing-library/user-event/dist/type';
import { MockContract, MockContractRet } from './file';
import { error } from 'console';


const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(<Guess />);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
