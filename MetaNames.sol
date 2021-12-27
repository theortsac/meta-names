// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract MetaNames {
    // Declaring the MetaName struct.
    struct MetaName {
        // A string that holds the name.
        string name;
        // An integer that holds the tag of the MetaName.
        uint256 tag;
    }

    // Declaring the event that will be trigered when a MetaName is registered.
    event NewName(MetaName metaName, address owner);
    // Declaring the event that will be trigered when a MetaName is entirely updated.
    event MetaNameChange(MetaName metaName, address owner);
    // Declaring the event that will be trigered when only the name of the MetaName is updated.
    event NameChange(MetaName metaName, address owner);
    // Declaring the event that will be trigered when only the tag of the MetaName is updated.
    event TagChange(MetaName metaName, address owner);

    // Declaring the mapping that receives the hash of the MetaName and gives the address of the user.
    mapping(bytes32 => address) metaNameToAddress;
    // Declaring the mapping that receives the hash of the address of the user and returns it's MetaName.
    mapping(address => MetaName) addressToMetaName;

    // Declaring the function that registers a new MetaName.
    function registerMetaName(string memory _name, uint256 _tag) public {
        // Declare the variable that stores the desired MetaName.
        MetaName memory metaName = MetaName(_name, _tag);
        // Get the desired MetaName hash.
        bytes32 metaNameHash = keccak256(
            abi.encode(metaName.name, metaName.tag)
        );
        // Require that the tag is below (or is) the maximum tag value.
        require(
            _tag <= 9999,
            "The tag number must be smaller or equal to 9999."
        );
        // Require that the tag is above 0.
        require(_tag > 0, "The tag number must be greater than 0.");
        // Require that the MetaName is not already registered.
        require(
            metaNameToAddress[metaNameHash] == address(0x0),
            "MetaName already has an owner."
        );
        // Require that the user has no previously registered MetaName.
        require(
            addressToMetaName[msg.sender].tag == 0,
            "You already have a MetaName registered."
        );
        // Set the MetaName to the user.
        metaNameToAddress[metaNameHash] = msg.sender;
        // Set the user's address to the MetaName he owns.
        addressToMetaName[msg.sender] = metaName;
        // Emit the event that the MetaName was registered.
        emit NewName(metaName, msg.sender);
    }

    // Declaring the function that updates completely a MetaName.
    function changeMetaName(string memory _name, uint256 _tag) public {
        // Declare the variable that stores the desired MetaName.
        MetaName memory metaName = MetaName(_name, _tag);
        // Get the desired MetaName hash.
        bytes32 metaNameHash = keccak256(
            abi.encode(metaName.name, metaName.tag)
        );
        // Require that the tag is below (or is) the maximum tag value.
        require(
            _tag <= 9999,
            "The tag number must be smaller or equal to 9999."
        );
        // Require that the tag is above 0.
        require(_tag > 0, "The tag number must be greater than 0.");
        // Require that the MetaName is not already registered.
        require(
            metaNameToAddress[metaNameHash] == address(0x0),
            "MetaName already has an owner."
        );
        // Require that the user has a registered MetaName.
        require(
            addressToMetaName[msg.sender].tag != 0,
            "You don't own a MetaName."
        );
        // Set the current owned MetaName to no owner.
        metaNameToAddress[
            keccak256(
                abi.encode(
                    addressToMetaName[msg.sender].name,
                    addressToMetaName[msg.sender].tag
                )
            )
        ] = address(0x0);
        // Set the desired MetaName to the user.
        metaNameToAddress[metaNameHash] = msg.sender;
        // Set the user's address to the MetaName.
        addressToMetaName[msg.sender] = metaName;
        // Emit the event that a MetaNames was updated.
        emit MetaNameChange(metaName, msg.sender);
    }

    // Declaring the function that updates the tag of a MetaName.
    function changeTag(uint256 _tag) public {
        // Declare the variable that stores the desired MetaName.
        MetaName memory metaName = MetaName(
            addressToMetaName[msg.sender].name,
            _tag
        );
        // Get the desired MetaName hash.
        bytes32 metaNameHash = keccak256(
            abi.encode(metaName.name, metaName.tag)
        );
        // Require that the tag is below (or is) the maximum tag value.
        require(
            _tag <= 9999,
            "The tag number must be smaller or equal to 9999."
        );
        // Require that the tag is above 0.
        require(_tag > 0, "The tag number must be greater than 0.");
        // Require that the MetaName is not already registered.
        require(
            metaNameToAddress[metaNameHash] == address(0x0),
            "MetaName already has an owner."
        );
        // Require that the user has a registered MetaName.
        require(
            addressToMetaName[msg.sender].tag != 0,
            "You don't own a MetaName."
        );
        // Set the current owned MetaName to no owner.
        metaNameToAddress[
            keccak256(
                abi.encode(
                    addressToMetaName[msg.sender].name,
                    addressToMetaName[msg.sender].tag
                )
            )
        ] = address(0x0);
        // Set the desired MetaName to the user.
        metaNameToAddress[metaNameHash] = msg.sender;
        // Change the tag of the user's MetaName.
        addressToMetaName[msg.sender].tag = _tag;
        // Emit the event that a MetaName tag was updated.
        emit TagChange(metaName, msg.sender);
    }

    // Declaring the function that updates the name of a MetaName.
    function changeName(string memory _name) public {
        // Declare the variable that stores the desired MetaName.
        MetaName memory metaName = MetaName(
            _name,
            addressToMetaName[msg.sender].tag
        );
        // Get the desired MetaName hash.
        bytes32 metaNameHash = keccak256(
            abi.encode(metaName.name, metaName.tag)
        );
        // Require that the desired MetaName has no owner.
        require(
            metaNameToAddress[metaNameHash] == address(0x0),
            "MetaName already has an owner."
        );
        // Require that the user has a registered MetaName.
        require(
            addressToMetaName[msg.sender].tag != 0,
            "You don't own a MetaName."
        );
        // Set the current owned MetaName to no owner.
        metaNameToAddress[
            keccak256(
                abi.encode(
                    addressToMetaName[msg.sender].name,
                    addressToMetaName[msg.sender].tag
                )
            )
        ] = address(0x0);
        // Set the desired MetaName to the user.
        metaNameToAddress[metaNameHash] = msg.sender;
        // Change the user's MetaName name to the desired one.
        addressToMetaName[msg.sender].name = _name;
        // Emit the event that a MetaName name was updated.
        emit NameChange(metaName, msg.sender);
    }

    // Declaring the function that returns the MetaName of a user.
    function addressMetaName(address _metaNameOwner)
        public
        view
        returns (MetaName memory)
    {
        // Access the mapping and return the MetaName of the address entered.
        return addressToMetaName[_metaNameOwner];
    }

    // Declaring the function that returns the user of a MetaName.
    function metaNameAddress(string memory _name, uint256 _tag)
        public
        view
        returns (address)
    {
        // Getting the hash of the entered MetaName and return it's user using the mapping.
        return metaNameToAddress[keccak256(abi.encode(_name, _tag))];
    }
}
