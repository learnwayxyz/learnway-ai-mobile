class CareerGoalOption {
  CareerGoalOption({required this.id, required this.title, required this.icon});

  final String id;
  final String title;
  final String icon;
}

final List<CareerGoalOption> predefinedCareerGoals = [
  CareerGoalOption(id: 'blockchain_dev', title: 'Blockchain Developer', icon: '⛓️'),
  CareerGoalOption(id: 'smart_contract', title: 'Smart Contract Engineer', icon: '📜'),
  CareerGoalOption(id: 'defi_analyst', title: 'DeFi Analyst', icon: '📊'),
  CareerGoalOption(id: 'crypto_trader', title: 'Crypto Trader', icon: '💹'),
  CareerGoalOption(id: 'web3_product', title: 'Web3 Product Manager', icon: '🚀'),
  CareerGoalOption(id: 'nft_creator', title: 'NFT Creator', icon: '🎨'),
  CareerGoalOption(id: 'dao_contributor', title: 'DAO Contributor', icon: '🏛️'),
  CareerGoalOption(id: 'web3_designer', title: 'Web3 UX Designer', icon: '✏️'),
];
