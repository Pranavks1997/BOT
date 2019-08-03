pragma solidity ^0.5.8;

contract Election {
mapping (address => bytes) public ids ;

	mapping (uint8 => address) public grpIdMasters  ; 
	mapping (uint8 => address) public BCTrustMember ;
	mapping (uint8 => string) public boxes ;


  	function BCTrustV2() public {

    	}
	
    function hasNoGroupId(uint8 _gid) public returns (bool) {
        if (grpIdMasters[_gid] != address(0)){
          return true;
        }
    }

	modifier ControlOf(uint8 sender, uint8 receiver) {
		address addrSender   = BCTrustMember[sender  ] ;
		address addrReceiver = BCTrustMember[receiver] ;

		if (addrSender == address(0))          
	        	revert() ;
	
		if (addrReceiver == address(0))          
	        	revert() ;
		

		if (ids[addrSender][0] != ids[addrReceiver][0])          
	        	revert() ;
	    	_ ;
	
	}

	modifier OnlyConcernedObject (uint8 addr) {
		if (BCTrustMember[addr] != msg.sender )          
	        	revert() ;
	    	_ ;
	}

	function BCTrustV2_AddNode (uint8 _category, uint8 _grpId, uint8 _id, uint256 _r, uint256 _s) public {
		if (bytes(ids[msg.sender]).length != 0)
			revert() ;

		if (BCTrustMember [_id] != address(0))
			revert() ;

		if (_category == 0) {
			if (grpIdMasters[_grpId] != address(0))
		        	revert() ;
		    	else {
		        	grpIdMasters  [_grpId] = msg.sender ;
		    	}
		} else {
			bytes memory inputData = BCTrustV2_BytesConcat(_grpId, _id, msg.sender) ;
		    	if (BCTrustV2_Verify (inputData, bytes32(_r), bytes32(_s), grpIdMasters[_grpId]) == false) {
				revert() ;
			}	
		}
			
		BCTrustMember [_id] = msg.sender            ;
		BCTrustV2_SaveNode(msg.sender, _grpId, _id) ;

	}
	
	function BCTrustV2_SaveNode(address _addr, uint8 _grpId, uint8 _id) public {
		
		ids[_addr] = BCTrustV2_Concat2Bytes(_grpId, _id) ;

	}

	function BCTrustV2_Concat2Bytes (uint8 v1, uint8 v2) public returns (bytes memory) {
		bytes memory res = new bytes(2) ;
		uint i = 0 ;
		
		res[i++] = byte(v1) ;
		res[i++] = byte(v2) ;

		return res ;
	}


	function BCTrustV2_Verify (bytes memory inputData, bytes32 _r, bytes32 _s, address masterAddr) public returns (bool) {

        	bytes32 hash = keccak256(inputData) ;
        	uint8   v    = 27 ;

        
        	if ((ecrecover(hash, v, _r, _s) == masterAddr) || (ecrecover(hash, v+1, _r, _s) == masterAddr)) 
            		return true ;
        	else
            		return false ;
	}

	
	function BCTrustV2_BytesConcat(uint8 v1, uint8 v2, address addr) internal returns (bytes memory) {
	    	bytes memory baddr = BCTrustV2_FromAddressToBytes(addr) ;
		bytes memory res   = new bytes (1 + 1 + 20) ;
        
		uint i = 0 ;
		res[i++] = byte(v1) ;
		res[i++] = byte(v2) ;
		uint j = 0 ;
		for (j = 0; j < 20; j++){
			res[i++] = baddr[j] ;
		}
		return res ;
	}

	function BCTrustV2_FromAddressToBytes(address a) view public returns (bytes memory b) {
        	assembly {
            		let m := mload(0x40)
			mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
			mstore(0x40, add(m, 52))
			b := m
         	}
    	}
    
    
    	function BCTrustV2_FromBytesToBytes32(bytes memory src) public returns (bytes32 res) {
        	assembly {
            		res := mload(add(src, 32))
        	}
    	}

	
	function BCTrustV2_Send (uint8 sender, uint8 receiver, string memory msg) ControlOf(sender, receiver) public {
		boxes[receiver] = msg ;
        }	

  
	function BCTrustV2_ReadMSG (uint8 addr) OnlyConcernedObject(addr) public returns (string memory) {
		return boxes[addr] ;
   	}

	function test() public returns (uint8) {
		return uint8(ids[msg.sender][0]) ;
	}
}
