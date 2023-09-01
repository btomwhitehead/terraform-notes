# HashiCorp Vault

Secure, store and tightly control access to tokens, passwords, certificates, encryption keys for protecting secrets and other sensitive data using a UI, CLI, or HTTP API.

Features:

- Secure Secret Storage: Arbitrary key/value secrets can be stored in Vault.
- Dynamic Secrets: Vault can generate secrets on-demand for some systems, such as AWS or SQL databases. For example, when an application needs to access an S3 bucket, it asks Vault for credentials, and Vault will generate an AWS keypair with valid permissions on demand.
- Data Encryption: Vault can encrypt and decrypt data without storing it.
- Leasing and Renewal: All secrets in Vault have a lease associated with them. At the end of the lease, Vault will automatically revoke that secret.
- Revocation: Vault has built-in support for secret revocation. Vault can revoke not only single secrets, but a tree of secrets, for example all secrets read by a specific user, or all secrets of a particular type.

Workflow:

- Authenticate: Authentication in Vault is the process by which a client supplies information that Vault uses to determine if they are who they say they are. Once the client is authenticated against an auth method, a token is generated and associated to a policy.
- Validation: Vault validates the client against third-party trusted sources, such as Github, LDAP, AppRole, and more.
- Authorize: A client is matched against the Vault security policy. This policy is a set of rules defining which API endpoints a client has access to with its Vault token. Policies provide a declarative way to grant or forbid access to certain paths and operations in Vault.
- Access: Vault grants access to secrets, keys, and encryption capabilities by issuing a token based on policies associated with the client’s identity. The client can then use their Vault token for future operations.

## Quickstart

Install locally with the [OS specific instruactions](https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-install).

Mac:

```sh
brew tap hashicorp/tap
brew install hashicorp/tap/vault
```

Run using a token `some_token`:

```sh
vault server -dev -dev-root-token-id="some_token"
```

## [vault provider](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)

The Vault provider allows Terraform to read from, write to, and configure HashiCorp Vault.

TODO
