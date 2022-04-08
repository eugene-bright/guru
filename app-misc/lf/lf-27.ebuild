# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module bash-completion-r1 desktop

SRC_URI="https://github.com/gokcehan/lf/archive/r${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/cantcuckthis/gentoo-lf/raw/main/${P}-deps.tar.xz"

DESCRIPTION="Terminal file manager"
HOMEPAGE="https://github.com/gokcehan/lf"
IUSE="+static"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="MIT"
SLOT="0"

S="${WORKDIR}/${PN}-r${PV}"

src_compile() {
	local ldflags="-s -w -X main.gVersion=r${PV}"
	use static && {
		export CGO_ENABLED=0
		ldflags+=' -extldflags "-static"'
	}

	go build -ldflags="${ldflags}" || die 'go build failed'
}

src_install() {
	local DOCS=( README.md etc/lfrc.example )

	dobin "${PN}"

	einstalldocs

	doman "${PN}.1"

	# bash & zsh cd
	insinto "/usr/share/${PN}"
	doins "etc/${PN}cd.sh"

	# bash-completion
	newbashcomp "etc/${PN}.bash" "${PN}"

	# zsh-completion
	insinto /usr/share/zsh/site-functions
	newins "etc/${PN}.zsh" "_${PN}"

	# fish-completion
	insinto /usr/share/fish/vendor_completions.d
	doins "etc/${PN}.fish"
	insinto /usr/share/fish/vendor_functions.d
	doins "etc/${PN}cd.fish"

	domenu "${PN}.desktop"
}
