// SPDX-License-Identifier: unlicenced
pragma solidity ^0.8.0;

contract My55Games {
    struct Game {
        uint256 gameId;
        string gameName;
        address payable seller;
        uint256 price;
        bool isSold;
    }

    mapping(uint256 => Game) public games;
    uint256 public gameCounter;

    event GameAdded(uint256 indexed gameId, string gameName, address indexed seller, uint256 price);
    event GameSold(uint256 indexed gameId, address indexed buyer);
    event Deposit(address indexed depositor, uint256 amount);
    event Withdraw(address indexed withdrawer, uint256 amount);

    function addGame(string memory _gameName, uint256 _price) public {
        gameCounter++;
        games[gameCounter] = Game(gameCounter, _gameName, payable(msg.sender), _price, false);
        emit GameAdded(gameCounter, _gameName, msg.sender, _price);
    }

    function buyGame(uint256 _gameId) public payable {
        Game storage game = games[_gameId];
        require(game.gameId != 0, "Game does not exist");
        require(!game.isSold, "Game is already sold");
        require(msg.value == game.price, "Incorrect payment amount");

        game.isSold = true;
        emit GameSold(_gameId, msg.sender);

        game.seller.transfer(msg.value);
    }

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public {
        require(_amount <= address(this).balance, "Insufficient contract balance");
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
