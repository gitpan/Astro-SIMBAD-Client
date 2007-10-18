use strict;
use warnings;

use t::TestSimbad;

t::TestSimbad::test (*DATA);

__DATA__

access

require XML::Parser XML::Parser::Lite

set type vo
set parser vo=Parse_VO_Table

query id Arcturus

count
want 1
test query id Arcturus (vo) - count of tables

# For a long time the following did not work. Because the problem
# appeared to be on the SIMBAD end, they were 'todo'.

deref 0 data
count
want 1
test query id arcturus (vo) - count of rows

deref 0 data 0 0 value
want <<eod
NAME ARCTURUS
eod
test query id Arcturus (vo) - name

deref 0 data 0 2 value
want 213.9153000
test query id Arcturus (vo) - right ascension

deref 0 data 0 3 value
want +19.1824103
test query id Arcturus (vo) - declination

deref 0 data 0 4 value
want 88.85
test query id Arcturus (vo) - parallax

deref 0 data 0 5 value
want -1093.43
test query id Arcturus (vo) - proper motion in right ascension

deref 0 data 0 6 value
want -1999.43
test query id Arcturus (vo) - proper motion in declination

deref 0 data 0 7 value
want -5.2
test query id Arcturus (vo) - radial velocity

# For a long time the previous was 'todo'

set parser script=Parse_VO_Table
script_file t/arcturus.vo

count
want 1
test script_file t/arcturus.vo - count table

deref 0 data
count
want 1
test script_file t/arcturus.vo - count rows

deref 0 data 0 0 value
want <<eod
NAME ARCTURUS
eod
test script_file t/arcturus.vo - name

deref 0 data 0 2 value
want 213.9153000
test script_file t/arcturus.vo - right ascension

deref 0 data 0 3 value
want +19.1824103
test script_file t/arcturus.vo - declination

deref 0 data 0 4 value
want 88.85
test script_file t/arcturus.vo - parallax

deref 0 data 0 5 value
want -1093.43
test script_file t/arcturus.vo - proper motion in right ascension

deref 0 data 0 6 value
want -1999.43
test script_file t/arcturus.vo - proper motion in declination

deref 0 data 0 7 value
want -5.2
test script_file t/arcturus.vo - radial velocity

url_query id Ident Arcturus

count
want 1
test url_query id Arcturus (vo) - count of tables

deref 0 data
count
want 1
test url_query id arcturus (vo) - count of rows

##deref 0 data 0 0 value
deref 0 data 0
find meta 1 name MAIN_ID
deref_curr value
want <<eod
NAME ARCTURUS
eod
test url_query id Arcturus (vo) - name

deref 0 data 0
find meta 1 name RA
deref_curr value
# want 213.9153
# As of about SIMBAD4 1.005 the default became sexigesimal
want <<eod
14 15 39.6720
eod
test url_query id Arcturus (vo) - right ascension

deref 0 data 0
find meta 1 name DEC
deref_curr value
# want +19.18241027778
# As of about SIMBAD4 1.005 the default became sexigesimal
want <<eod
+19 10 56.677
eod
test qurl_uery id Arcturus (vo) - declination

deref 0 data 0
find meta 1 name PLX_VALUE
deref_curr value
want 88.85
test url_query id Arcturus (vo) - parallax

deref 0 data 0
find meta 1 name PMRA
deref_curr value
want -1093.43
test url_query id Arcturus (vo) - proper motion in right ascension

deref 0 data 0
find meta 1 name PMDEC
deref_curr value
want -1999.43
test url_query id Arcturus (vo) - proper motion in declination

deref 0 data 0
find meta 1 name oRV:RVel
deref_curr value
want -5.2
test url_query id Arcturus (vo) - radial velocity

