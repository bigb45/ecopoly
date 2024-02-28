import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/models/tax.dart';
import 'package:ecopoly/models/card.dart';

List<Cell> board = [
  Cell(
      name: 'Go',
      imageName: 'assets/images/jail.png',
      index: 0,
      type: CellType.start),
  Property(
    imageName: "assets/images/spain.png",
    name: "Madrid",
    index: 1,
    cost: 60,
    rent: 2,
    type: CellType.property,
    setIndex: 0,
  ),
  Cell(
      imageName: "assets/images/surprise.png",
      name: "Surprise",
      index: 2,
      type: CellType.chance),
  Property(
    cost: 60,
    rent: 4,
    imageName: "assets/images/spain.png",
    name: "Barcelona",
    index: 3,
    type: CellType.property,
    setIndex: 0,
  ),
  Tax(
      percentage: 0.15,
      imageName: "assets/images/tax.png",
      name: "Income Tax",
      index: 4),
  Property(
    cost: 200,
    rent: 25,
    imageName: "assets/images/bike_lane.png",
    name: "Bike lane",
    index: 5,
    type: CellType.bikelane,
    setIndex: 8,
  ),
  Property(
    cost: 120,
    rent: 6,
    imageName: "assets/images/india.png",
    name: "Mumbai",
    index: 6,
    type: CellType.property,
    setIndex: 1,
  ),
  Cell(
      imageName: "assets/images/community_chest.jpg",
      name: "Charity",
      index: 7,
      type: CellType.charity),
  Property(
    cost: 100,
    rent: 6,
    imageName: "assets/images/india.png",
    name: "Delhi",
    index: 8,
    type: CellType.property,
    setIndex: 1,
  ),
  Property(
    cost: 100,
    rent: 6,
    imageName: "assets/images/india.png",
    name: "Bangalore",
    index: 9,
    type: CellType.property,
    setIndex: 1,
  ),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Jail",
      index: 10,
      type: CellType.jail),

  // Second row
  Property(
    cost: 140,
    rent: 10,
    imageName: "assets/images/turkey.png",
    name: "Istanbul",
    index: 11,
    type: CellType.property,
    setIndex: 2,
  ),
  Property(
    cost: 150,
    rent: 10,
    imageName: "assets/images/solaris.png",
    name: "Solaris Energy",
    index: 12,
    type: CellType.utility,
    setIndex: 9,
  ),

  Property(
    cost: 160,
    rent: 12,
    imageName: "assets/images/turkey.png",
    name: "Ankara",
    index: 13,
    type: CellType.property,
    setIndex: 2,
  ),
  Property(
    cost: 140,
    rent: 10,
    imageName: "assets/images/turkey.png",
    name: "Izmir",
    index: 14,
    type: CellType.property,
    setIndex: 2,
  ),
  Property(
    cost: 200,
    rent: 25,
    imageName: "assets/images/bike_lane.png",
    name: "Bike lane",
    index: 15,
    type: CellType.bikelane,
    setIndex: 8,
  ),
  Property(
    cost: 200,
    rent: 20,
    imageName: "assets/images/sweden.png",
    name: "Stockholm",
    index: 16,
    type: CellType.property,
    setIndex: 3,
  ),
  Cell(
      imageName: "assets/images/community_chest.jpg",
      name: "Charity",
      index: 17,
      type: CellType.charity),
  Property(
    cost: 180,
    rent: 14,
    imageName: "assets/images/sweden.png",
    name: "Gothenburg",
    index: 18,
    type: CellType.property,
    setIndex: 3,
  ),
  Property(
    cost: 180,
    rent: 14,
    imageName: "assets/images/sweden.png",
    name: "Malmo",
    index: 19,
    type: CellType.property,
    setIndex: 3,
  ),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Free Parking",
      index: 20,
      type: CellType.freeParking),

  // Third row
  Property(
    cost: 240,
    rent: 20,
    imageName: "assets/images/australia.png",
    name: "Sydney",
    index: 21,
    type: CellType.property,
    setIndex: 4,
  ),
  Cell(
      imageName: "assets/images/surprise.png",
      name: "Surprise",
      index: 22,
      type: CellType.chance),
  Property(
    cost: 220,
    rent: 18,
    imageName: "assets/images/australia.png",
    name: "Melbourne",
    index: 23,
    type: CellType.property,
    setIndex: 4,
  ),
  Property(
    cost: 220,
    rent: 18,
    imageName: "assets/images/australia.png",
    name: "Brisbane",
    index: 24,
    type: CellType.property,
    setIndex: 4,
  ),
  Property(
    cost: 200,
    rent: 25,
    imageName: "assets/images/bike_lane.png",
    name: "Bike lane",
    index: 25,
    type: CellType.bikelane,
    setIndex: 8,
  ),
  Property(
    cost: 280,
    rent: 24,
    imageName: "assets/images/canada.png",
    name: "Toronto",
    index: 26,
    type: CellType.property,
    setIndex: 5,
  ),
  Property(
    cost: 260,
    rent: 24,
    imageName: "assets/images/canada.png",
    name: "Montreal",
    index: 27,
    type: CellType.property,
    setIndex: 5,
  ),
  Property(
    cost: 150,
    rent: 20,
    imageName: "assets/images/recycling.jpg",
    name: "Recycling Plant",
    index: 28,
    type: CellType.utility,
    setIndex: 9,
  ),
  Property(
    cost: 240,
    rent: 22,
    imageName: "assets/images/canada.png",
    name: "Vancouver",
    index: 29,
    type: CellType.property,
    setIndex: 5,
  ),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Go to Jail",
      index: 30,
      type: CellType.goToJail),

  // Fourth row
  Property(
    cost: 300,
    rent: 26,
    imageName: "assets/images/usa.png",
    name: "New York",
    index: 31,
    type: CellType.property,
    setIndex: 6,
  ),
  Cell(
      imageName: "assets/images/surprise.png",
      name: "Surprise",
      index: 32,
      type: CellType.chance),
  Property(
    cost: 300,
    rent: 26,
    imageName: "assets/images/usa.png",
    name: "Los Angeles",
    index: 33,
    type: CellType.property,
    setIndex: 6,
  ),
  Property(
    cost: 320,
    rent: 28,
    imageName: "assets/images/usa.png",
    name: "Washington DC",
    index: 34,
    type: CellType.property,
    setIndex: 6,
  ),
  Property(
    cost: 200,
    rent: 25,
    imageName: "assets/images/bike_lane.png",
    name: "Bike lane",
    index: 35,
    type: CellType.bikelane,
    setIndex: 8,
  ),
  Cell(
      imageName: "assets/images/community_chest.jpg",
      name: "Charity",
      index: 36,
      type: CellType.charity),
  Property(
    cost: 350,
    rent: 35,
    imageName: "assets/images/japan.png",
    name: "Tokyo",
    index: 37,
    type: CellType.property,
    setIndex: 7,
  ),
  Tax(
    amount: 75,
    imageName: "assets/images/fixed_tax.jpg",
    name: "Environmental Tax",
    index: 38,
  ),
  Property(
    cost: 400,
    rent: 50,
    imageName: "assets/images/japan.png",
    name: "Osaka",
    index: 39,
    type: CellType.property,
    setIndex: 7,
  ),
];

List<GameCard> chanceCards = const [
  GameCard(
    title: 'Ocean Cleanup Reward',
    description:
        'Receive \$200 as a reward for participating in an ocean cleanup initiative and contributing to marine life protection.',
    amount: 200,
  ),
  GameCard(
    title: 'Community Garden Harvest',
    description:
        'Enjoy a bountiful harvest from your community garden project. Receive \$100 from selling fresh, locally grown produce.',
    amount: 100,
  ),
  GameCard(
    title: 'Electric Vehicle Incentive',
    description:
        'Earn \$50 for each electric vehicle you own, as part of an incentive program to promote eco-friendly transportation.',
    amount: 50,
  ),
  GameCard(
    title: 'Solar Energy Savings',
    description:
        'You saved money on energy bills with your solar panel installation. Enjoy \$50',
    amount: 50,
  ),
  GameCard(
    title: 'National Park Contribution',
    description:
        'Receive \$150 from national park preservation efforts. Your contribution helps protect natural habitats and wildlife.',
    amount: 150,
  ),
  GameCard(
    title: 'Recycling Initiative Payout',
    description:
        'Receive \$75 for consistently participating in recycling programs and reducing waste in your community.',
    amount: 75,
  ),
  GameCard(
    title: 'Energy-Efficient Home Rebate',
    description:
        'Qualified for a \$250 rebate for upgrading to energy-efficient appliances and making your home more sustainable.',
    amount: 250,
  ),
  GameCard(
    title: 'Clean Transportation Bonus',
    description:
        'Get rewarded with \$100 for regularly using public transportation and cycling to reduce carbon emissions.',
    amount: 100,
  ),
  GameCard(
    title: 'Renewable Energy Dividends',
    description:
        'Earn \$50 in dividends for investing in renewable energy stocks and supporting the transition to clean energy sources.',
    amount: 50,
  ),
  GameCard(
    title: 'Eco-Friendly Business Grant',
    description:
        'Receive a \$500 grant for implementing eco-friendly practices in your business operations and promoting sustainability.',
    amount: 500,
  ),
];

List<GameCard> surpriseCards = const [
  GameCard(
    title: "Windfall!",
    description: "You won a local eco-friendly contest. Collect \$200.",
    amount: 200,
  ),
  GameCard(
    title: "Solar Panel Mishap",
    description: "Your solar panels need repairs. Pay \$100 for maintenance.",
    amount: -100,
  ),
  GameCard(
    title: "Clean Energy Tax Credit",
    description: "Received a tax credit for using clean energy. Collect \$150.",
    amount: 150,
  ),
  GameCard(
    title: "Carbon Tax",
    description: "Pay a carbon tax for excessive emissions. Pay \$50.",
    amount: -50,
  ),
  GameCard(
    title: "Green Innovation Grant",
    description: "Received a grant for green innovation. Collect \$200.",
    amount: 300,
  ),
  GameCard(
    title: "Eco-Friendly Transportation",
    description: "Invested \$75 in eco-friendly transportation. ",
    amount: -75,
  ),
  GameCard(
    title: "Recycling Rebate",
    description: "Received a rebate for recycling efforts. Collect \$50.",
    amount: 50,
  ),
  GameCard(
    title: "Drought Emergency",
    description:
        "Experience a drought emergency. Pay \$200 for water conservation efforts.",
    amount: -200,
  ),
  GameCard(
    title: "Renewable Energy Investment",
    description:
        "Invested in renewable energy stocks. Earn \$100 in dividends.",
    amount: 100,
  ),
  GameCard(
    title: "Green Tax Credit",
    description:
        "Received a tax credit for eco-friendly home upgrades. Collect \$250.",
    amount: 250,
  ),
];
