#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Environment
MKDIR=mkdir
CP=cp
GREP=grep
NM=nm
CCADMIN=CCadmin
RANLIB=ranlib
CC=gcc
CCC=g++
CXX=g++
FC=
AS=as

# Macros
CND_PLATFORM=GNU-Linux-x86
CND_CONF=AInvestLib
CND_DISTDIR=dist

# Include project Makefile
include Makefile

# Object Directory
OBJECTDIR=build/${CND_CONF}/${CND_PLATFORM}

# Object Files
OBJECTFILES= \
	${OBJECTDIR}/enfoque.o \
	${OBJECTDIR}/main.o


# C Compiler Flags
CFLAGS=

# CC Compiler Flags
CCFLAGS=
CXXFLAGS=

# Fortran Compiler Flags
FFLAGS=

# Assembler Flags
ASFLAGS=

# Link Libraries and Options
LDLIBSOPTIONS=-L../AInvestLib/dist/Debug/GNU-Linux-x86 ../AInvestLib/dist/Debug/GNU-Linux-x86/libainvestlib.a

# Build Targets
.build-conf: ${BUILD_SUBPROJECTS}
	"${MAKE}"  -f nbproject/Makefile-AInvestLib.mk dist/AInvestLib/GNU-Linux-x86/ddcenfoque

dist/AInvestLib/GNU-Linux-x86/ddcenfoque: ../AInvestLib/dist/Debug/GNU-Linux-x86/libainvestlib.a

dist/AInvestLib/GNU-Linux-x86/ddcenfoque: ${OBJECTFILES}
	${MKDIR} -p dist/AInvestLib/GNU-Linux-x86
	${LINK.c} -o ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/ddcenfoque ${OBJECTFILES} ${LDLIBSOPTIONS} 

${OBJECTDIR}/enfoque.o: enfoque.c 
	${MKDIR} -p ${OBJECTDIR}
	${RM} $@.d
	$(COMPILE.c) -O2 -I../AInvestLib -MMD -MP -MF $@.d -o ${OBJECTDIR}/enfoque.o enfoque.c

${OBJECTDIR}/main.o: main.c 
	${MKDIR} -p ${OBJECTDIR}
	${RM} $@.d
	$(COMPILE.c) -O2 -I../AInvestLib -MMD -MP -MF $@.d -o ${OBJECTDIR}/main.o main.c

# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/AInvestLib
	${RM} dist/AInvestLib/GNU-Linux-x86/ddcenfoque

# Subprojects
.clean-subprojects:

# Enable dependency checking
.dep.inc: .depcheck-impl

include .dep.inc
