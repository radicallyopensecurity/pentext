# Changelog

## [2.3.0](https://github.com/radicallyopensecurity/pentext/compare/2.2.0...2.3.0) (2024-04-18)

### ⚠ IMPORTANT CHANGES

- Rename default branch to `main`: Please don't forget to update your local clone.

### Features

* Configure GitLab CI/CD ([16bde45](https://git.go-forward.net/radicallyopensecurity/pentext/-/commit/16bde45da7843bba0d2777d8609baf27ce4e63a0))
* express effort in weeks (in addition to days) ([a98b936](https://git.go-forward.net/radicallyopensecurity/pentext/-/commit/a98b936eed8de166ab0eedcf5f658c6c4acbe306))
* make futurework snippet less specific ([daece47](https://git.go-forward.net/radicallyopensecurity/pentext/-/commit/daece47ddc671332e00530ca769b89a1bc39df7c))
* remove hidden inline links (aria-hidden=true) ([28a191f](https://git.go-forward.net/radicallyopensecurity/pentext/-/commit/28a191f3b4b68028b0f3bef4b21bf00453a4ad5b))
* support different image width units (incl %) ([8b74a08](https://git.go-forward.net/radicallyopensecurity/pentext/-/commit/8b74a0868807f4f2bfcad5ea589f9d742a683880))


### Bug Fixes

* ignore template label tag ([14579a8](https://git.go-forward.net/radicallyopensecurity/pentext/-/commit/14579a856d6be937d699fe872eee30b3899a51ff))

## [2.2.0](https://github.com/radicallyopensecurity/pentext/compare/2.1.1...2.2.0) (2024-01-16)


### Features

* add ability to create multiple tables ([9ceba05](https://github.com/radicallyopensecurity/pentext/commit/9ceba05dfbfcf9d50f7c1685cb1395509d5e989c))
* add retest-status to CSV finding export ([040c122](https://github.com/radicallyopensecurity/pentext/commit/040c122ecc48b9df8949fb6cc4b4611d76a0c450))
* change type of pentest from string to enum ([5367dd9](https://github.com/radicallyopensecurity/pentext/commit/5367dd9e22e58f026657936fc56c0f7008ce89fd))
* pentest type is an enum ([6e5edc7](https://github.com/radicallyopensecurity/pentext/commit/6e5edc7a870979a42cf8e6797d98068709724ebd))


### Bug Fixes

* don't show the content of labels in the finding itself ([aa0f479](https://github.com/radicallyopensecurity/pentext/commit/aa0f4798bcc6c2df6d63e48860dbf42e980fc610))
* ensure that (sample) generic documents can be created again ([ae23ce9](https://github.com/radicallyopensecurity/pentext/commit/ae23ce9279a41c4070b8a14db713e0cfd1be13e6))
* ensure that template contains number ([497365b](https://github.com/radicallyopensecurity/pentext/commit/497365bded4ca7f8b3bac6a651e2a2614315de87))

## [2.1.1](https://github.com/radicallyopensecurity/pentext/compare/2.1.0...2.1.1) (2023-02-08)

### Bug Fixes

- **snippet:** point to website for portfolio
  ([89ca1d6](https://github.com/radicallyopensecurity/pentext/commit/89ca1d6740726a93718570e636d5fac322beb7db))

## [2.1.0](https://github.com/radicallyopensecurity/pentext/compare/2.0.0...2.1.0) (2023-01-20)

### Features

- add support for finding labels
  ([8d966b2](https://github.com/radicallyopensecurity/pentext/commit/8d966b2cb0d0ec3209a5a396288be21719eb463c))
- ensure sample report builds again
  ([b70dcf0](https://github.com/radicallyopensecurity/pentext/commit/b70dcf004321d35d93a6513695d2dcd8133cde39))
- **xsl:** add jira csv target
  ([18234d7](https://github.com/radicallyopensecurity/pentext/commit/18234d724a2ac0726fd1dbd9246327c6d07c6536))

## [2.0.0](https://github.com/radicallyopensecurity/pentext/compare/1.1.0...2.0.0) (2022-09-27)

### ⚠ BREAKING CHANGES

- move framework from xml subdirectory to root

### Features

- move framework from xml subdirectory to root
  ([4cf2c5a](https://github.com/radicallyopensecurity/pentext/commit/4cf2c5afbffbe144d8dff1468f6a096d68e9e927))
- remove chatops setup scripts /remnants
  ([2af48c3](https://github.com/radicallyopensecurity/pentext/commit/2af48c3d6cd47ff98b0dbb5a28380b72d3108d71))
- remove chatops tools from repository
  ([36c8164](https://github.com/radicallyopensecurity/pentext/commit/36c8164d249910abebb18e971ac24fc614bfa233))
- remove PenText framework update script
  ([bb15ff4](https://github.com/radicallyopensecurity/pentext/commit/bb15ff4ec58864f942aec21c7b1bd43fad61183a))
- remove previous roadmap
  ([c4c5f8c](https://github.com/radicallyopensecurity/pentext/commit/c4c5f8c8485475a636734a25fb1800d3fbfc058a))
- remove unmaintained editor
  ([f25410a](https://github.com/radicallyopensecurity/pentext/commit/f25410aa389fec3d4f4733dfb1158e963fb96ab1))

## 1.1.0 (2022-09-16)

### Features

- add section id for methodology
  ([6cd2a5a](https://github.com/radicallyopensecurity/pentext/commit/6cd2a5a8a1fb24d2bf395a191e008cd022d07c07))
- add support for p_draftdue placeholder
  ([afec8cd](https://github.com/radicallyopensecurity/pentext/commit/afec8cdd64784669ffbd3bc65151022e544e9e31))
- add support for strikethrough text
  ([a337798](https://github.com/radicallyopensecurity/pentext/commit/a337798d6a0e103fed7b1fd64dd6960ab0336a91))
- allow empty background graphics
  ([5cebd02](https://github.com/radicallyopensecurity/pentext/commit/5cebd02ab1a47c2f6e3f74c89ac37e2944d4c11b))
- correct typo, and use proper section tags
  ([c6aad31](https://github.com/radicallyopensecurity/pentext/commit/c6aad3174b785ba687caa75b449f2f2d546e522c))

### Bug Fixes

- (schema) add blockquote definition
  ([85546ec](https://github.com/radicallyopensecurity/pentext/commit/85546ecb1bb5804121c332c81203dc7bddcc66df))
- logmessage failed when learning new words
  ([957812f](https://github.com/radicallyopensecurity/pentext/commit/957812f7d7b8ee5c74803f3362c63a774518cedd))
- logmessage failed when learning new words
  ([0b499b6](https://github.com/radicallyopensecurity/pentext/commit/0b499b68e79982291d68c737fb098bf692a83f23))
- remove unused graphics
  ([046594f](https://github.com/radicallyopensecurity/pentext/commit/046594f97499f8760a4b48456450b813ea1fcca7))
- threat summaries are correct when selecting status
  ([9c46510](https://github.com/radicallyopensecurity/pentext/commit/9c4651066ac0e73c07105b1d97c50bd87d32b077))
- typo
  ([3314f82](https://github.com/radicallyopensecurity/pentext/commit/3314f82afecb4bd6de926c33ff492adf13f761bd))
- update to latest version of OWASP Top 10
  ([2054306](https://github.com/radicallyopensecurity/pentext/commit/20543068cf0771b080aea3a3fc17df7890300196))
- use quoting and correct number in CSV export
  ([de4f35f](https://github.com/radicallyopensecurity/pentext/commit/de4f35ffd6eb823c4c6ce6122dfbc717f7afd430))
