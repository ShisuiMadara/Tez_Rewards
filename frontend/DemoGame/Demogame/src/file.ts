import { type } from "@testing-library/user-event/dist/type";

export { MockContract };
export type MockContractRet = {
    result: boolean;
    Num: number;
}
let MockContract: (a: number, b: number) => MockContractRet;
MockContract = function (num: number, level: number) {
    let max: number = 0;
    if (level == 1) max = 10;
    if (level == 2) max = 100;
    if (level == 3) max = 1000;
    if (level == 4) max = 10000;
    max = Math.floor(Math.random() * max) + 1;
    if (max == num) return { result: true, Num: max };
    return { result: false, Num: max };
}