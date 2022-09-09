PORTNAME=	Eternal-Lands-data
DISTVERSION=	1.9.6.1
CATEGORIES=	games
MASTER_SITES=	https://github.com/raduprv/Eternal-Lands/releases/download/${DISTVERSION}/
DISTFILES=	${EL_DATA}
DIST_SUBDIR=	${PORTNAME}

MAINTAINER=	acm@FreeBSD.org
COMMENT=	Eternal Lands data, sound, and music files

NO_ARCH=	yes
NO_BUILD=	yes
USES=		dos2unix zip:infozip
DOS2UNIX_GLOB=	*.ini *.txt

CONFLICTS=      el-data
DATADIR=	${PREFIX}/share/${PORTNAME}
WRKSRC=		${WRKDIR}/${PORTNAME}
EL_DATA=	eternallands-data_${DISTVERSION}${EXTRACT_SUFX}
# https://github.com/raduprv/Eternal-Lands/releases/download/1.9.6.1/eternallands-data_1.9.6.1.zip

PORTDATA=	*

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
	@${MKDIR} ${WRKSRC}
	@${UNZIP_CMD} -q ${_DISTDIR}/${EL_DATA} -d ${WRKDIR}
.if ${PORT_OPTIONS:MELSOUND}
	@${UNZIP_CMD} -q ${_DISTDIR}/eternallands-sound_${DISTVERSION}${EXTRACT_SUFX} -d ${WRKSRC}
.endif
.if ${PORT_OPTIONS:MELMUSIC}
	@${MKDIR} ${WRKSRC}/music
	@${UNZIP_CMD} -q ${_DISTDIR}/eternallands-music_1.9.5.9${EXTRACT_SUFX} -d ${WRKSRC}/music
.endif

post-extract:
	@${FIND} ${WRKSRC} -type d -name CVS -print0 | \
		${XARGS} -0 ${RM} -R
	@${FIND} ${WRKSRC} -type f -name "*.dll" -print0 | \
		${XARGS} -0 ${RM} -R
	@${FIND} ${WRKSRC} -type f -name "*.exe" -print0 | \
		${XARGS} -0 ${RM} -R
	@${FIND} ${WRKSRC} -type f -name "*.bin" -print0 | \
		${XARGS} -0 ${RM} -R

do-install:
	cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${DATADIR}

.include <bsd.port.mk>
