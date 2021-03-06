/*
   Copyright 2016-2017 Nexus Development, LLC

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

pragma solidity ^0.4.9;

import "dapple/test.sol";

import "auth.sol";
import "authority.sol";

contract FakeVault is DSAuth {
    function access() auth {}
}

contract BooleanAuthority is DSAuthority {
    bool value;
    function BooleanAuthority(bool _value) { value = _value; }
    function canCall(
        address caller, address code, bytes4 sig
    ) constant returns (bool) {
        return value;
    }
}

contract DSAuthTest is Test, DSAuthEvents {
    FakeVault vault = new FakeVault();
    BooleanAuthority rejector = new BooleanAuthority(false);

    function test_owner() {
        expectEventsExact(vault);
        vault.access();
        vault.setAuthority(DSAuthority(0));
        LogSetAuthority(DSAuthority(0));
    }

    function testFail_non_owner_1() {
        vault.setAuthority(DSAuthority(0));
        vault.access();
    }

    function testFail_non_owner_2() {
        vault.setAuthority(DSAuthority(0));
        vault.setAuthority(DSAuthority(0));
    }

    function test_accepting_authority() {    
        vault.setAuthority(new BooleanAuthority(true));
        vault.access();
    }

    function testFail_rejecting_authority_1() {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setAuthority(DSAuthority(0));
        vault.access();
    }

    function testFail_rejecting_authority_2() {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setAuthority(DSAuthority(0));
        vault.setAuthority(DSAuthority(0));
    }

    function testFail_rejecting_authority_3() {
        vault.setAuthority(new BooleanAuthority(false));
        vault.setAuthority(DSAuthority(0));
        vault.setAuthority(DSAuthority(0));
    }
}

