const { expect } = require('chai');

describe('ICO', function () {
	let JagguToken;
	let owner;
	let addr1;
	let addr2;
	let addrs;
	
	beforeEach(async () => {
		[owner, addr1, addr2, ...addrs] = await ethers.getSigners();
		const contract = await ethers.getContractFactory('ICO');
		JagguToken = await contract.deploy();
	});
	
	describe('Deployment', () => {
		it('Should give the total supply to the owner', async () => {
			const ownerBalance = await JagguToken.balanceOf(owner.address);
			expect(await JagguToken.totalSupply()).to.equal(ownerBalance);
		});
	});
	
	describe('Transactions', () => {
		it('Should buy JagguTokens with ether', async () => {
			const amount = ethers.utils.parseEther('5');
			const wallet = JagguToken.connect(addr2);
			const trial = { value: amount };
			const calculate = (trial.value).mul(200000);

			await wallet.buyTokens(trial);
			expect(await wallet.balanceOf(addr2.address)).to.equal(calculate);
		});

		it('Should fail if sender has insufficient JagguTokens', async () => {
			const initialOwnerBalance = await JagguToken.balanceOf(
				owner.address
			);
			const wallet = JagguToken.connect(addr2);

			await expect(wallet.transfer(addr1.address, 1)).to.be.reverted;
			expect(await JagguToken.balanceOf(owner.address)).to.equal(
				initialOwnerBalance
			);
		});
	});
});
