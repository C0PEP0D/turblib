CC     = gcc -g
LD     = gfortran -g
RM     = rm -f
CFLAGS = -Wall -g -I..
LDLIBS = 

OBJ =	soapC.o \
	soapClient.o \
	stdsoap2.o \
        turblib.o

all: turbf turbc

turbf : $(OBJ) turbf.o
	 $(LD) -o $@ $(OBJ) turbf.o $(LDLIBS)

turbc : $(OBJ) turbc.o
	 $(LD) -o $@ $(OBJ) turbc.o $(LDLIBS)

turbf.o : turbf.f90
	gfortran -g -c turbf.f90

stdsoap2.o: stdsoap2.c
	$(CC) $(CFLAGS) -c $<

# Regenerate the gSOAP interfaces if required
TurbulenceService.h : updatewsdl

# Update the WSDL and gSOAP interfaces
wsdl:
	wsdl2h -o TurbulenceService.h -n turb -c "http://turbulence.pha.jhu.edu/service/turbulence.asmx?WSDL" -l -s
	soapcpp2 -CLcx -2 TurbulenceService.h

clean:
	$(RM) *.o turbf turbc

spotless: clean
	$(RM) soapClient.c TurbulenceServiceSoap.nsmap  soapH.h TurbulenceServiceSoap12.nsmap soapStub.h soapC.c TurbulenceService.h

lib: $(OBJ)

.SUFFIXES:
.SUFFIXES: .o .c .x


.c.o:
	$(CC) $(CFLAGS) -c $< 

