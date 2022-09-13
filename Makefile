PORTNAME=	Eternal-Lands-data
DISTVERSION=	1.9.6.1
CATEGORIES=	games
MASTER_SITES=	https://github.com/raduprv/Eternal-Lands/releases/download/${DISTVERSION}/
DISTFILES=	eternallands-data_${DISTVERSION}${EXTRACT_SUFX}
DIST_SUBDIR=	${PORTNAME}

MAINTAINER=	acm@FreeBSD.org
COMMENT=	Eternal Lands data, sound, and music files

NO_ARCH=	yes
NO_BUILD=	yes
USES=		dos2unix zip:infozip
DOS2UNIX_GLOB=	*.ini *.lst *.txt *.xml
DOS2UNIX_WRKSRC= ${WRKSRC}/el_data
# Note that dos2unix occurs before other patches.

CONFLICTS=      el-data
DATADIR=	${PREFIX}/share/${PORTNAME}
WRKSRC=		${WRKDIR}/${PORTNAME}-${DISTVERSION}
# https://github.com/raduprv/Eternal-Lands/releases/download/1.9.6.1/eternallands-data_1.9.6.1.zip
# pkg will complain about duplicate plist entries if portdata is used, prefer proper pkg-plist instead.
#PORTDATA=	*

OPTIONS_DEFINE=		ELSOUND ELMUSIC
OPTIONS_DEFAULT=	ELSOUND ELMUSIC
ELSOUND_DESC=		Install additional sound files
ELMUSIC_DESC=		Install additional music files

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MELSOUND}
DISTFILES+=	eternallands-sound_${DISTVERSION}${EXTRACT_SUFX}
.endif

# Note at present the music version is behind.
.if ${PORT_OPTIONS:MELMUSIC}
DISTFILES+=	eternallands-music_1.9.5.9${EXTRACT_SUFX}
.endif

do-extract:
	@${UNZIP_CMD} -q ${_DISTDIR}/eternallands-data_${DISTVERSION}${EXTRACT_SUFX} -d ${WRKSRC}
	# The data files have their own directory, el_data which is created upon extract.
.if ${PORT_OPTIONS:MELSOUND}
	@${UNZIP_CMD} -q ${_DISTDIR}/eternallands-sound_${DISTVERSION}${EXTRACT_SUFX} -d ${WRKSRC}/el_data
	# Sound has its own directory which is created upon extract.
.endif
.if ${PORT_OPTIONS:MELMUSIC}
	@${MKDIR} ${WRKSRC}/el_data/music
	@${UNZIP_CMD} -q ${_DISTDIR}/eternallands-music_1.9.5.9${EXTRACT_SUFX} -d ${WRKSRC}/el_data/music
.endif

do-install:
	cd ${WRKSRC}/el_data && ${COPYTREE_SHARE} . ${STAGEDIR}${DATADIR}
#
# The music and sounds need to be directories inside of the path defined for the el_data files.

.include <bsd.port.mk>
