import { expect } from "chai";
import { ethers } from "hardhat";

describe("LaborDay", function () {

    let laborDay: any;
    let LaborDay: any;

    before(async () => {

        LaborDay = await ethers.getContractFactory("LaborDay");

    })

    beforeEach(async () => {

        laborDay = await LaborDay.deploy();

    })

    describe('greet function', () => {

        it('says the default happy labor day greeting', async () => {

            expect(await laborDay.greet()).to.equal('Happy Labor Day!')

        })

        it('says the labor day greeting to a named person', async () => {

            expect(await laborDay.greet2('Texas Farmer')).to.equal('Happy Labor Day Texas Farmer!')
            expect(await laborDay.greet2('Jim_!@#$^')).to.equal('Happy Labor Day Jim_!@#$^!')
            expect(await laborDay.greet2('الْحُرُوف الْعَرَبِيَّ')).to.equal('Happy Labor Day الْحُرُوف الْعَرَبِيَّ!')
            expect(await laborDay.greet2('Santa Claus1')).to.equal('Happy Labor Day Santa Claus1!')

        })

        it('says the special greeting for Santa Claus', async () => {

            expect(await laborDay.greet2('Santa Claus')).to.equal('OMG I am so glad you called this function, Santa!')

        })

    })

    it('starts counter at one', async () => {

        expect(await laborDay.counter()).to.equal(1);

    })

})