// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

/// @dev Status of an account in the verification system. In general the
/// interface is designed to be extensible so that new statuses can be added
/// in the future without breaking existing contracts. The standard values are
/// defined as constants below, these are strongly recommended to be used
/// if there are no domain specific requirements for the status.
type VerifyStatus is uint256;

/// @dev Account has not interacted with the system yet or was removed.
VerifyStatus constant VERIFY_STATUS_NIL = VerifyStatus.wrap(0);
/// @dev Account has added evidence for themselves.
VerifyStatus constant VERIFY_STATUS_ADDED = VerifyStatus.wrap(1);
/// @dev Approver has reviewed added/approve evidence and approved the account.
VerifyStatus constant VERIFY_STATUS_APPROVED = VerifyStatus.wrap(2);
/// @dev Banner has reviewed a request to ban an account and banned it.
VerifyStatus constant VERIFY_STATUS_BANNED = VerifyStatus.wrap(3);

/// Structure of arbitrary evidence to support any action taken.
/// Privileged roles are expected to provide evidence just as applicants as an
/// audit trail will be preserved permanently in the logs.
/// @param account The account this evidence is relevant to.
/// @param data Arbitrary bytes representing evidence. MAY be e.g. a reference
/// to a sufficiently decentralised external system such as an IPFS hash.
struct Evidence {
    address account;
    bytes data;
}

/// @title IVerifyV1
/// Interface for a verification system that allows accounts to be added,
/// approved, banned, and removed with the standard statuses. In general the
/// interface is designed to be extensible so that new actions can be added
/// in the future without breaking existing contracts, or the standard actions
/// could be ignored by the implementation.
/// The main purpose of this interface is to allow contracts to query the
/// status of an account at a given point in time, which is useful for
/// determining whether an account is, was or will be allowed to perform certain
/// actions.
/// Note that this is somewhat different but in a way complementary to RBAC
/// systems for authorization. Where an RBAC system has many roles and a single
/// binary decision of whether an account has a role or not, this system has
/// a single "role" (verified) and a set of statuses related to that concept of
/// verification.
/// Ostensibly this system is designed for use in KYC and AML compliance
/// systems, where the final outcome is a singular positive state or some reason
/// why it is not in that state. For example, some account could be a well known
/// bad actor and therefore be permanently banned from the system, or it could
/// be a new account awaiting review by administrators after submitting some
/// supporting KYC evidence.
/// The interface is agnostic to state changes, it only cares about the final
/// reading, which allows for maximum flexibility in the implementation. By
/// design downstream contracts are supposed to have no knowledge or expectations
/// on the implementation specifics.
interface IVerifyV1 {
    /// Returns the status of the account at the specified timestamp.
    /// Implementing contracts MAY revert if the status cannot be determined
    /// but typically the expectation is that some status representing the
    /// failure mode is returned such that the caller can handle it.
    /// @param account The account to check the status of.
    /// @param timestamp The timestamp to check the status at, in seconds since
    /// the Unix epoch.
    /// @return The status of the account at the specified timestamp.
    function accountStatusAtTime(address account, uint256 timestamp) external view returns (VerifyStatus);
}
