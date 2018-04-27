# Packaging

## Generating GPG keys for signing

Generating GPG keys suitable for signing Debian packages and repository files involves multiple steps. These instructions detail those steps, and presume the user name of the key will be 'Test User', the email address will be 'test.user@example.com', and the password will be 'password'.

The following command will generate an authoritative GPG key within the `keyring` directory of the present project (select the default kind of key, RSA):

```sh
# gpg --homedir=./keyring --full-gen-key
```

Example output:

```
GnuPG needs to construct a user ID to identify your key.

Real name: Test User
Email address: test.user@example.com
Comment:
You selected this USER-ID:
    "Test User <test.user@example.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: /some/directory/./keyring/trustdb.gpg: trustdb created
gpg: key 205D882FB364A0C1 marked as ultimately trusted
gpg: directory '/some/directory/./keyring/openpgp-revocs.d' created
gpg: revocation certificate stored as /some/directory/./keyring/openpgp-revocs.d/0123456789ABCDEF0123456789ABCDEF01234567.rev'
public and secret key created and signed.

pub   rsa1024 2000-01-01 [SC]
      0123456789ABCDEF0123456789ABCDEF01234567
uid                      Test User <test.user@example.com>
sub   rsa1024 2000-01-01 [E]
```

Note: it may take a few minutes to generate the key. Afterwards, verify the key is present:

```sh
# gpg --homedir=./keyring --list-keys
gpg: WARNING: unsafe permissions on homedir '/some/directory/./keyring'
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
/some/directory/./keyring/pubring.kbx
----------------------------------------------------------------------------------
pub   rsa1024 2000-01-01 [SC]
      0123456789ABCDEF0123456789ABCDEF01234567
uid           [ultimate] Test User <test.user@example.com>
sub   rsa1024 2000-01-01 [E]
```

The warning about unsafe permissions can be corrected by revoking read/write/execute permissions for all but the current user:

```sh
# chmod 700 ./keyring
```

Run the above `gpg --homedir=./keyring --list-keys` command again to verify that the warning has been lifted.

This public key will need to be published, and anyone wishing to add repositories signed via gpg will need to add this public key to their keychains.

To locally add the public key to apt for testing, run `sudo apt-key add settings/repository.key.gpg`.
