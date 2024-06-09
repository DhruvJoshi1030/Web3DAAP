const ExpenseManagerContract = artifacts("ExpenseManagerContract");

module.exports = function (deployer){
    deployer.deploy(ExpenseManagerContract);
};