# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=ELMEX
inherit perl-module

DESCRIPTION="Object::Event - A class that provides an event callback interface"

LICENSE="|| ( Artistic GPL-1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-perl/AnyEvent
		 dev-perl/common-sense"
