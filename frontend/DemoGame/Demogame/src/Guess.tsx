import React from 'react';
import { useState, useEffect } from "react";
import ReactDOM from 'react-dom/client';
import { useForm, SubmitHandler } from "react-hook-form";
import './index.css';
import reportWebVitals from './reportWebVitals';
import { type } from '@testing-library/user-event/dist/type';
import { MockContract, MockContractRet } from './file';
import { error } from 'console';

type LvlBtnPrp = {
    value: string;
    onClick: () => void;
    highlighted: boolean;
}

type LvlSelState = {
    chosen: number;
}

function LevelButtons(props: LvlBtnPrp) {
    if (props.highlighted) {
        return (
            <button className="button button2" onClick={() => { return; }}>{props.value}</button>
        );
    }
    else {
        return (
            <button className="button" onClick={props.onClick}>{props.value}</button>
        );
    }
}

class LevelSelect extends React.Component {
    state: LvlSelState;
    constructor(props: {}) {
        super(props);
        this.state = {
            chosen: 0,
        }
    }
    handleClick(i: number) {
        this.setState({
            chosen: i,
        });
    }
    renderLvlBtn(i: number) {
        let highlight: boolean;
        if (this.state.chosen == i) highlight = true;
        else highlight = false;
        return <LevelButtons value={i.toString()} onClick={() => this.handleClick(i)} highlighted={highlight} />;
    }
    render() {
        return (
            <div>
                <div>
                    {this.renderLvlBtn(1)}
                    <br />
                    {this.renderLvlBtn(2)}
                    <br />
                    {this.renderLvlBtn(3)}
                    <br />
                    {this.renderLvlBtn(4)}
                </div>
                <GuessForm Level={this.state.chosen} />
            </div>
        );
    }
}

interface IFormInput {
    Level: number;
    Amount: number;
    Number: number;
}

function GuessForm(props: { Level: number; }) {
    const [Data, setData] = useState<IFormInput>({ Level: props.Level, Amount: 0, Number: -1 });
    const [Result, setResult] = useState<MockContractRet>({ result: false, Num: -1 })
    useEffect(() => {
        setData({ ...Data, Level: props.Level });
    }, [props.Level]);
    let limit: number = Math.pow(10, Data.Level);
    const { register, formState: { errors }, handleSubmit } = useForm<IFormInput>();
    const onSubmit: SubmitHandler<IFormInput> = data => {
        data.Level = Data.Level;
        setData(data);
        let res = MockContract(Data.Number, Data.Level);
        setResult({ ...Result, result: res.result, Num: res.Num });
    };
    if (Data.Level == 0) return (
        <div> Please Choose Level!</div>
    );

    return (
        <span>
            <br />
            <br />
            <form onSubmit={handleSubmit(onSubmit)}>
                <label>Amount</label><br />
                <input {...register("Amount", { required: true, max: 100, min: 1 })} />
                {errors.Amount && errors.Amount.type === "required" && (
                    <div>Please Enter Amount!</div>
                )}
                {errors.Amount && (errors.Amount.type === "max" || errors.Amount.type === "min") && (
                    <div>Amount between 1 and 100 only!</div>
                )} <br />
                <label>Your Guess</label><br />
                <input {...register("Number", { required: true, max: limit, min: 1 })} />
                {errors.Number && errors.Number.type === "required" && (
                    <div>Please Enter Your Guess!</div>
                )}
                {errors.Number && (errors.Number.type === "max" || errors.Number.type === "min") && (
                    <div>Guess between 1 and {limit} only!</div>
                )} <br />
                <input type="submit" />
            </form>
            <ResultGuess Choice={Data.Number} Num={Result.Num} result={Result.result} />
        </span>
    );
}

type ResultProp = {
    result: boolean;
    Num: number;
    Choice: number;
}

function ResultGuess(props: ResultProp) {
    if (props.Num == -1) {
        return (
            <div> Please make a guess to see the result </div>
        );
    }
    else {
        return (
            <div>
                <p> The number You guessed: {props.Choice} </p>
                <p> The Resulting Number: {props.Num}</p>
                {props.result && <p> Therfore You Won! </p>}
                {!props.result && <p> Therfore You Lost! </p>}
            </div>
        );
    }
}

class Guess extends React.Component {
    render() {
        return (
            <div>
                <LevelSelect />
            </div>
        );
    }
}

export default Guess;
