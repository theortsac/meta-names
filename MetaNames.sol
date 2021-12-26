// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract MetaNames {
    struct MetaName {
        string name;
        uint256 tag;
    }

    event NewName(MetaName metaName, address owner);
    event MetaNameChange(MetaName metaName, address owner);
    event NameChange(MetaName metaName, address owner);
    event TagChange(MetaName metaName, address owner);

    mapping(bytes32 => address) metaNameToAddress;
    mapping(address => MetaName) addressToMetaName;

    function registerMetaName(string memory _name, uint256 _tag) public {
        MetaName memory metaName = MetaName(_name, _tag);
        bytes32 metaNameHash = keccak256(
            abi.encode(metaName.name, metaName.tag)
        );
        require(
            _tag <= 9999,
            "The tag number must be smaller or equal to 9999."
        );
        require(_tag > 0, "The tag number must be greater than 0.");
        require(
            metaNameToAddress[metaNameHash] == address(0x0),
            "MetaName already has an owner."
        );
        require(
            addressToMetaName[msg.sender].tag == 0,
            "You already have a MetaName registered."
        );
        metaNameToAddress[metaNameHash] = msg.sender;
        addressToMetaName[msg.sender] = metaName;
        emit NewName(metaName, msg.sender);
    }

    function changeMetaName(string memory _name, uint256 _tag) public {
        MetaName memory metaName = MetaName(_name, _tag);
        bytes32 metaNameHash = keccak256(
            abi.encode(metaName.name, metaName.tag)
        );
        require(
            _tag <= 9999,
            "The tag number must be smaller or equal to 9999."
        );
        require(_tag > 0, "The tag number must be greater than 0.");
        require(
            metaNameToAddress[metaNameHash] == address(0x0),
            "MetaName already has an owner."
        );
        require(
            addressToMetaName[msg.sender].tag != 0,
            "You don't own a MetaName."
        );
        metaNameToAddress[
            keccak256(
                abi.encode(
                    addressToMetaName[msg.sender].name,
                    addressToMetaName[msg.sender].tag
                )
            )
        ] = address(0x0);
        metaNameToAddress[metaNameHash] = msg.sender;
        addressToMetaName[msg.sender] = metaName;
        emit MetaNameChange(metaName, msg.sender);
    }

    function changeTag(uint256 _tag) public {
        MetaName memory metaName = MetaName(
            addressToMetaName[msg.sender].name,
            _tag
        );
        bytes32 metaNameHash = keccak256(
            abi.encode(metaName.name, metaName.tag)
        );
        require(
            _tag <= 9999,
            "The tag number must be smaller or equal to 9999."
        );
        require(_tag > 0, "The tag number must be greater than 0.");
        require(
            metaNameToAddress[metaNameHash] == address(0x0),
            "MetaName already has an owner."
        );
        require(
            addressToMetaName[msg.sender].tag != 0,
            "You don't own a MetaName."
        );
        metaNameToAddress[
            keccak256(
                abi.encode(
                    addressToMetaName[msg.sender].name,
                    addressToMetaName[msg.sender].tag
                )
            )
        ] = address(0x0);
        metaNameToAddress[metaNameHash] = msg.sender;
        addressToMetaName[msg.sender].tag = _tag;
        emit TagChange(metaName, msg.sender);
    }

    function changeName(string memory _name) public {
        MetaName memory metaName = MetaName(
            _name,
            addressToMetaName[msg.sender].tag
        );
        bytes32 metaNameHash = keccak256(
            abi.encode(metaName.name, metaName.tag)
        );
        require(
            addressToMetaName[msg.sender].tag <= 9999,
            "The tag number must be smaller or equal to 9999."
        );
        require(
            addressToMetaName[msg.sender].tag > 0,
            "The tag number must be greater than 0."
        );
        require(
            metaNameToAddress[metaNameHash] == address(0x0),
            "MetaName already has an owner."
        );
        require(
            addressToMetaName[msg.sender].tag != 0,
            "You don't own a MetaName."
        );
        metaNameToAddress[
            keccak256(
                abi.encode(
                    addressToMetaName[msg.sender].name,
                    addressToMetaName[msg.sender].tag
                )
            )
        ] = address(0x0);
        metaNameToAddress[metaNameHash] = msg.sender;
        addressToMetaName[msg.sender].name = _name;
        emit NameChange(metaName, msg.sender);
    }

    function addressMetaName(address _metaNameOwner)
        public
        view
        returns (MetaName memory)
    {
        return addressToMetaName[_metaNameOwner];
    }

    function metaNameAddress(string memory _name, uint256 _tag)
        public
        view
        returns (address)
    {
        return metaNameToAddress[keccak256(abi.encode(_name, _tag))];
    }
}
