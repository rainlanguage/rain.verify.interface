# rain.verify.interface

A minimal interface for contracts to implement representing "verification".

The most common intended use case is KYC/AML requirements, where users will
submit various forms of evidence to adminstrators who will review the evidence
and then either approve, ignore or reject/ban the user.

In general verification could apply to a wider range of domains than simply KYC
so the interface is designed to be agnostic to both the implementation and even
the specific status codes returned.