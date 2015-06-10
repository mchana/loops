#############################################################################
##
#W  examples.gi              Examples [loops]
##  
#H  @(#)$Id: examples.gi, v 3.0.0 2015/06/10 gap Exp $
##  
#Y  Copyright (C)  2004,  G. P. Nagy (University of Szeged, Hungary),  
#Y                        P. Vojtechovsky (University of Denver, USA)
##

#############################################################################
##  Binding gobal variable LOOPS_aux 
##
##  The variable is used for temporary storage throughout the package. 
##  We therefore do not want the variable to be read only.

LOOPS_aux := [];

#############################################################################
##  READING DATA
##  -------------------------------------------------------------------------

# up to isomorphism
ReadPackage("loops", "data/leftbol.tbl");       # left Bol loops
ReadPackage("loops", "data/moufang.tbl");       # Moufang loops
ReadPackage("loops", "data/paige.tbl");         # Paige loops
ReadPackage("loops", "data/code.tbl");          # code loops
ReadPackage("loops", "data/steiner.tbl");       # Steiner loops
ReadPackage("loops", "data/cc.tbl");            # CC loops
ReadPackage("loops", "data/rcc.tbl");           # RCC loops (more is read upon calling RCCLoop(n,m) for the first time
ReadPackage("loops", "data/small.tbl");         # small loops
ReadPackage("loops", "data/interesting.tbl");   # interesting loops
ReadPackage("loops", "data/nilpotent.tbl");     # nilpotent loops
ReadPackage("loops", "data/automorphic.tbl");   # automorphic loops

# up to isotopism
ReadPackage("loops", "data/itp_small.tbl");     # small loops up to isotopism

#############################################################################
##  DISPLAYING INFORMATION ABOUT A LIBRARY
##  -------------------------------------------------------------------------

#############################################################################
##  
#F  LOOPS_LibraryByName( name ) 
##    
##  Auxiliary. Returns the library corresponding to <name>.

InstallGlobalFunction( LOOPS_LibraryByName, 
function( name )
    #up to isomorphism
    if name = "left Bol" then return LOOPS_left_bol_data; 
    elif name = "Moufang" then return LOOPS_moufang_data;
    elif name = "Paige" then return LOOPS_paige_data;
    elif name = "code" then return LOOPS_code_data;
    elif name = "Steiner" then return LOOPS_steiner_data;
    elif name = "CC" then return LOOPS_cc_data;
    elif name = "RCC" then return LOOPS_rcc_data;
    elif name = "small" then return LOOPS_small_data;
    elif name = "interesting" then return LOOPS_interesting_data;
    elif name = "nilpotent" then return LOOPS_nilpotent_data;
    elif name = "automorphic" then return LOOPS_automorphic_data;
    #up to isotopism
    elif name = "itp small" then return LOOPS_itp_small_data;
    fi;
end);

#############################################################################
##  
#F  DisplayLibraryInfo( name ) 
##    
##  Display information about library named <name>.

InstallGlobalFunction( DisplayLibraryInfo, function( name )
    local s, lib, k;
    # up to isomorphism
    if name = "left Bol" then
        s := "The library contains all nonassociative left Bol loops of order less than 17.";
    elif name = "right Bol" then
        s := "The library contains all nonassociative right Bol loops of order less than 17.";
        name := "left Bol"; # using dual data
    elif name = "Moufang" then
        s := "The library contains all nonassociative Moufang loops \nof order less than 65, and all nonassociative Moufang \nloops of order 81 and 243.";
    elif name = "Paige" then
        s := "The library contains the smallest nonassociative finite \nsimple Moufang loop.";
    elif name = "code" then
        s := "The library contains all nonassociative even code loops \nof order less than 65.";
    elif name = "Steiner" then
        s := "The library contains all nonassociative Steiner loops \nof order less or equal to 16. It also contains the \nassociative Steiner loops of order 4 and 8.";
    elif name = "CC" then
        s := "The library contains all nonassociative CC loops of order less than 28 \nand all nonassociative CC loops of order p^2 and 2*p for any odd prime p.";
    elif name = "RCC" then
        s := "The library contains all nonassociative RCC loops of order less than 28.";
    elif name = "LCC" then
        s := "The library contains all nonassociative LCC loops of order less than 28.";
        name := "RCC"; # using dual data
    elif name = "small" then
        s := "The library contains all nonassociative loops of order less than 7.";
    elif name = "interesting" then
        s := "The library contains a few interesting loops.";
    elif name = "nilpotent" then
        s := "The library contains all nonassociative nilpotent loops \nof order less than 12.";
    elif name = "automorphic" then
        s := "The library contains all nonassociative automorphic loops \nof order less than 16.";
    # up to isotopism
    elif name = "itp small" then
        s := "The library contains all nonassociative loops of order less than 7 up to isotopism.";
    else
        Info( InfoWarning, 1, Concatenation(
            "The admissible names for loop libraries are: \n",
            "[ \"left Bol\", \"right Bol\", \"Moufang\", \"Paige\", \"code\", \"Steiner\", \"CC\", \"RCC\", \"LCC\", \"small\", \"itp small\", \"interesting\", \"nilpotent\", \"automorphic\" ]."
        ) );
        return fail;
    fi;
    
    s := Concatenation( s, "\n------\nExtent of the library:" );
    
    lib := LOOPS_LibraryByName( name );
    for k in [1..Length( lib[ 1 ] ) ] do
        if lib[ 2 ][ k ] = 1 then
            s := Concatenation( s, "\n   ", String( lib[ 2 ][ k ] ), " loop of order ", String( lib[ 1 ][ k ] ) );
        else
            s := Concatenation( s, "\n   ", String( lib[ 2 ][ k ] ), " loops of order ", String( lib[ 1 ][ k ] ) );
        fi;
    od;
    if name = "CC" then
        s := Concatenation( s, "\n   3 loops of order p^2 for every odd prime p,\n   1 loop of order 2*p for every odd prime p" );
    fi;
    s := Concatenation( s, "\n" );
    Print( s );
    return true;
end);

#############################################################################
##  AUXILIARY FUNCTIONS
##  -------------------------------------------------------------------------
##  When the data in the database is encoded in some way, we usually
##  retrieve the loop via function LOOPS_ActivateXLoop, where X is the name 
##  of the class.

#############################################################################
##  
#F  LOOPS_ActivateLeftBolLoop( pos ) 
##    
##  Retrieves the <pos>th left Bol loop of order <n>.
##  The position <pos> is precalculated via PosInDB (see below).

InstallGlobalFunction( LOOPS_ActivateLeftBolLoop,
function( pos )
    local rep_pos, ct, perm;
    # the left Bol loop activation
    
    rep_pos := pos;
    # searching for a Cayley table on which the loop is based
    while not IsString( LOOPS_left_bol_data[ 3 ][ rep_pos ] ) do 
        rep_pos := rep_pos - 1;
    od;
    if rep_pos = pos then
        # loop given by encoded Cayley table
        ct := LOOPS_DecodeCayleyTable( LOOPS_left_bol_data[ 3 ][ pos ] );
    else
        # loop given as an isotope of another loop
        ct := LOOPS_DecodeCayleyTable( LOOPS_left_bol_data[ 3 ][ rep_pos ] );
        perm := PermList( ct[ LOOPS_left_bol_data[ 3 ][ pos ] ] );
        ct := Set( List( ct, row -> OnTuples( row, perm^-1 ) ) );
    fi;
    return LoopByCayleyTable( ct );
    
end);

#############################################################################
##  
#F  LOOPS_ActivateMoufangLoop( pos, n ) 
##    
##  Auxiliary function for activating Moufang loops from the database.
##  <pos> is the position of the loop in the database. 
##  <n> is the order of the loops

InstallGlobalFunction( LOOPS_ActivateMoufangLoop,
function( pos, n )
    local d, UnpackCocycle, parent_pos, parent, S, a, h, e, f, G, ret, x, row, y, b, c, z;
    
    d := LOOPS_moufang_data[ 3 ][ pos ]; #data
    
    # orders 81 and 243 are represented as central extensions
    if n = 81 or n = 243 then 
        # auxiliary routine for unpacking cocycle from strings to arrays
        UnpackCocycle := function( s )
            local n, coc, i, j;
            s := List( s, char -> Position( "123456789", char ) );
            n := Sqrt( Length( s ) );
            coc := List([1..n], i -> 0*[1..n]);
            for i in [1..n] do for j in [1..n] do
                coc[i][j] := s[ (i-1)*n + j ];
            od; od;
            return coc;
        end;
        
        # calling LOOPS routine "LoopByExtension"
        return LoopByExtension( 
            IntoLoop( SmallGroup( d[1], d[2] ) ), # K
            IntoLoop( SmallGroup( d[3], d[4] ) ), # F
            List([1..d[3]], i -> () ), # trivial action F -> Aut( K )
            UnpackCocycle( d[ 5 ] ) # cocycle
        );
    fi;
    
    # all other orders
    if d[ 1 ] > 0 then # must activate parent first
        #determine position of parent
        parent_pos := pos - 1;
        while LOOPS_moufang_data[ 3 ][ parent_pos ][ 1 ] > 0 do 
            parent_pos := parent_pos - 1;
        od;
        parent_pos := parent_pos + d[ 1 ] - 1;
        parent := LOOPS_ActivateMoufangLoop( parent_pos, 0  ); # order not important

        if d[ 2 ] = "C" then #cyclic modification
            S := List( d[ 3 ], i -> Elements( parent )[ i ] );
            a := Elements( parent )[ d[ 4 ] ];
            h := Elements( parent )[ d[ 5 ] ];
            return LoopByCyclicModification( parent, S, a, h );
        fi;

        if d[ 2 ] = "D" then # dihedral modification
            S := List( d[ 3 ], i -> Elements( parent )[ i ] );
            e := Elements( parent )[ d[ 4 ] ];
            f := Elements( parent )[ d[ 5 ] ];
            h := Elements( parent )[ d[ 6 ] ];
            return LoopByDihedralModification( parent, S, e, f, h );
        fi;
    fi;

    # no parent; 
    if d[ 2 ]="G" then # loop of type MG2
        G := AllGroups( d[ 3 ], IsCommutative, false)[ d[ 4 ] ];  #relies on GAP group libraries !!
        return LoopMG2( G );
    fi;
    if d[ 2 ]="T" then # special loop (direct product of an old loop and a cyclic group)
        parent := MoufangLoop( d[ 3 ][ 1 ], d[ 3 ][ 2 ]);
        return DirectProduct( parent, CyclicGroup( d[ 3 ][ 3 ] ) );    
    fi;

end);

#############################################################################
##  
#F  LOOPS_ActivateSteinerLoop( pos, n ) 
##    
##  Auxiliary function activating Steiner loops from the database.
##  <pos> is the position of the loop in the database.
##  <n> is the order of the loop.
## 
##  The database LOOPS_steiner_data contains blocks of steiner triple systems.
##  If the system is on k points, the poitns are labelled 0,...,k-1.
##  The constructed Steiner loop has elements labelled 1,...,k+1=n

InstallGlobalFunction( LOOPS_ActivateSteinerLoop,
function( pos, n )
    local d, blocks, i, T, i_in, ij_in, j, MyInt;

    #############################################################################
    ##  
    #F  MyInt( s ) 
    ##    
    ##  Auxiliary function. 
    ##  Given a digit or a lower case letter, returns the numerical value, where
    ##  a = 10, f=15

    MyInt := function( s )
        return Position( "0123456789abcdef", s ) - 1;
    end;
    
    d := LOOPS_steiner_data[ 3 ][ pos ]; # data for the loop = three strings 
    #creating the blocks
    blocks := []; 
    for i in [1..Length( d[ 1 ] )] do
        Add( blocks, [ MyInt( d[1][i] ), MyInt( d[2][i] ), MyInt( d[3][i] ) ] );
    od;
    
    #creating the multiplication table
    T := List( [1..n], i->[1..n] );
    for i in [1..n] do T[i][1] := i; od;
    for i in [0..n-2] do 
        i_in := Filtered( blocks, B->i in B);
        for j in [0..n-2] do
            if j=i then T[i+2][j+2] := 1; fi;
            if not j=i then
                ij_in := Filtered( i_in, B->j in B )[1]; #unique block;
                T[i+2][j+2] := Difference( ij_in, [i,j])[1] + 2;
            fi;
        od;
    od;
    
    return LoopByCayleyTable( T );
end);

#############################################################################
##  
#F  LOOPS_ActivateRCCLoop( n, m ) 
##    
##  Activates an RCC loop from the library.
##  See manual for complete discussion concerning this library.

InstallGlobalFunction( LOOPS_ActivateRCCLoop,
function( n, m )
    local pos_n, pos_m, g, nr_conj_classes, data, data2, next_compactified, x, i, rel_m, G, section, pos_conjugacy_classes;

    pos_n := Position( LOOPS_rcc_data[ 1 ], n );
    if  IsEmpty( LOOPS_rcc_transitive_groups ) then # data not read yet
        ReadPackage( "loops", "data/rcc/rcc_transitive_groups.tbl" );
    fi;
    # determining the transitive group corresponding to pos_n, m
    pos_m := Length( LOOPS_rcc_data[ 3 ][ pos_n ][ 1 ] ); # nr of transitive groups associated with order n
    while LOOPS_rcc_data[ 3 ][ pos_n ][ 2 ][ pos_m ] > m do 
        pos_m := pos_m - 1;
    od;
    g := LOOPS_rcc_data[ 3 ][ pos_n ][ 1 ][ pos_m ]; # index of transitive group (of degree n) in GAP library
    # activating data for the group, if needed
    if not IsBound( LOOPS_rcc_sections[ pos_n ][ pos_m ] ) then
        # data must be read from file and decoded
        ReadPackage( "loops", Concatenation( "data/rcc/sections", String(n), ".", String(g), ".tbl" ) );
        # variable LOOPS_aux is now read and ready to be processed
        nr_conj_classes := Length( LOOPS_rcc_transitive_groups[ pos_n ][ pos_m ][ 2 ] );
        data := SplitString( LOOPS_aux, " " );
        data2 := [];
        next_compactified := false;
        for x in data do 
            if x="" then # the next entry is compactified, eg. "a$X" means "a", "$", "X"
                next_compactified := true;
            elif not next_compactified then
                Add( data2, x );
            else # compactified string
                next_compactified := false;
                for i in [1..Length(x)] do
                    Add( data2, x{[i..i]} );    # Add( data2, x[i] ) is not safe when data2 is empty
                od;
            fi;
        od;
        data := List( data2, x -> LOOPS_ConvertToDecimal( x, 91 ) ); 
        # reconstructing the sequence from the difference sequence
        for i in [2..Length( data )] do
            data[ i ] := data[ i-1 ] - data[ i ];
        od;
        LOOPS_rcc_sections[ pos_n ][ pos_m ] := data; 
    fi;
    # data is now loaded
    G := TransitiveGroup(n, g);
    rel_m := m - LOOPS_rcc_data[ 3 ][ pos_n ][ 2 ][ pos_m ] + 1;  # relative position of the loop in the file for G
    section := [];
    nr_conj_classes := Length( LOOPS_rcc_transitive_groups[ pos_n ][ pos_m ][ 2 ] );
    if not LOOPS_rcc_conjugacy_classes[ 1 ] = [ n, g ] then # must calculate conjugacy classes, so let's reset old data
        LOOPS_rcc_conjugacy_classes[ 1 ] := [ n, g ];
		LOOPS_rcc_conjugacy_classes[ 2 ] := List( [1..nr_conj_classes], x->[] );
    fi;
	x := LOOPS_rcc_sections[ pos_n ][ pos_m ][ rel_m ];
	x := LOOPS_ConvertFromDecimal( x, 2, nr_conj_classes ); # convert to a binary string of prescribed length
	pos_conjugacy_classes := Positions( x, '1' );
    for i in [1..nr_conj_classes] do
        if LOOPS_rcc_conjugacy_classes[ 2 ][ i ] = [] then
            LOOPS_rcc_conjugacy_classes[ 2 ][ i ] := Elements( ConjugacyClass( G, LOOPS_rcc_transitive_groups[ pos_n ][ pos_m ][ 2 ][ i ] ) );
        fi;
    od;
	section := Concatenation( LOOPS_rcc_conjugacy_classes[ 2 ]{pos_conjugacy_classes} );
    Add( section, One( G ) ); # the trivial class is contained in all loops and never stored
    Sort( section );
    return LoopByRightSection( section );
end);

#############################################################################
##  
#F  LOOPS_ActivateCCLoop( n, m, is_p_case ) 
##    
##  Activates a CC-loop from the library.
##  The argument is_p_case is set to true if n = p^2 or n=2*p for an odd prime p.
##  See manual for complete discussion concerning this library.

InstallGlobalFunction( LOOPS_ActivateCCLoop,
function( n, m, is_p_case )
    local pos_n, T, x, y, k, a, b, p, SmallestNonsquare;
    
    if not is_p_case then # use library of RCC loops
        pos_n := Position( LOOPS_cc_data[ 1 ], n );
        return LOOPS_ActivateRCCLoop( n, LOOPS_cc_data[ 3 ][ pos_n ][ m ] ); 
    fi;

    #############################################################################
    ##  
    #F  SmallestNonsquare( p ) 
    ##    
    ##  Auxiliary function. 
    ##  Returns the smallest nonsquare modulo p.

    SmallestNonsquare := function( p )
        local squares, i;
        squares := Set( [1..p-1], i->i^2 mod p );
        for i in [1..p-1] do 
            if not i in squares then return i; fi;
        od;
        return fail; #will never happen
    end;

    # parameters n, m are already checked to be permissible
    if (n mod 2) = 0 then # of the form 2*p
        p := n/2;
        T := List( [1..n], i -> [1..n ] );
        for a in [0..p-1] do for b in [0..p-1] do
            T[a+1][b+1]:= ((a+b) mod p) + 1;
            T[a+1][p+b+1] := p + ((-a+b) mod p ) + 1;
            T[p+a+1][b+1] := p + ((a+b) mod p) + 1;
            T[p+a+1][p+b+1] := ((1-a+b) mod p) + 1;
        od; od;
        return LoopByCayleyTable( T );
    fi;

    # of the form p^2
    p := Sqrt( n );
    T := List([1..n], i->[1..n]);
    if m = 1 then
        for x in [0..n-1] do for y in [0..n-1] do
            T[ x+1 ][ y+1 ] := ((x + y + p*(x^2)*y) mod n) + 1;
        od; od;
    elif m = 2 then
        k := SmallestNonsquare( p );
        for x in [0..n-1] do for y in [0..n-1] do
            T[ x+1 ][ y+1 ] := ((x + y + k*p*(x^2)*y) mod n) + 1;
        od; od;
    elif m = 3 then
        for x in [0..p-1] do for y in [0..p-1] do for a in [0..p-1] do for b in [0..p-1] do
            T[ x*p+a+1 ][ y*p+b+1 ] := ((x+y) mod p)*p + ((a+b+(x^2)*y) mod p) + 1;
        od; od; od; od; 
    fi;
    return LoopByCayleyTable( T );
end);

#############################################################################
##  
#F  LOOPS_ActivateNilpotentLoop( data ) 
##    
##  Activates the nilpotent loop based on data = [ K, F, t ], where
##  K determines a central (normal) subloop,
##  F determines the factor loop, 
##  t determines the cocycle.
##  Understanding K and F:
##      If the value of K or F is in [2,3,4,5], it is the cyclic group of order V.
##      If the value of K or F is 0, it is the Klein group.
##  Understanding t:
##      The cocycle is mapping from F x F to K. Let f = |F|. Let k = |K|.
##      The value t corresponds to a (f-1)x(f-1) array of values in [0..k-1].
##      It is represented by a single integer in base k, with the least 
##      significant digit in the first row and first column, then following
##      the rows.
##      Once t is decoded into a (f-1)x(f-1) array, 1 is added to all entries.
##      Then a first row and forst column of all ones is added to t,
##      resulting in a f x f array.
##  The loop is then obtained via LoopByExtension( K, F, phi, t), where
##  phi is trivial.

InstallGlobalFunction( LOOPS_ActivateNilpotentLoop,
function( data )
    local K, F, f, k, t, theta, i, j, phi;
    
    # preparing normal subloop and factor loop
    if data[ 1 ] = 0 then 
        K := IntoLoop( Group( (1,2),(3,4) ) ); 
    else
        K := IntoLoop( CyclicGroup( data[ 1 ] ) );
    fi;
    if data[ 2 ] = 0 then 
        F := IntoLoop( Group( (1,2),(3,4) ) );
    else
        F := IntoLoop( CyclicGroup( data[ 2 ] ) );    
    fi;
    
    # preparing cocycle
    f := Size( F );
    k := Size( K );
    t := data[ 3 ];
    theta := List( [1..f], i->[1..f] );
    for i in [2..f] do
        theta[ 1 ][ i ] := 1;
    od;
    for i in [2..f] do for j in [2..f] do
        theta[ i ][ j ] := t mod k;
        t := (t - theta[i][j])/k;
        theta[ i ][ j ] := theta[ i ][ j ] + 1;
    od; od;
    
    # preparing trivial action
    phi := List([1..f], i -> () );
    
    # constructing the loop
    return LoopByExtension( K, F, phi, theta );

end);     

#############################################################################
##  READING LOOPS FROM THE LIBRARY - GENERIC METHOD
##  -------------------------------------------------------------------------

#############################################################################
##  
#F  LibraryLoop( name, n, m ) 
##  
##  returns the <m>th loop of order <n> from the library named <name>

InstallGlobalFunction( LibraryLoop, function( name, n, m )

    local lib, implemented_orders, NOL, loop, pos_n, p, PG, m_inv, PosInDB, root, half, is_CC_p_case, g, h;

    # selecting data library
    if name = "right Bol" then # using dual data
        lib := LOOPS_LibraryByName( "left Bol" );
    elif name = "LCC" then # using dual data
        lib := LOOPS_LibraryByName( "RCC" );
    else
        lib := LOOPS_LibraryByName( name );
    fi;

    # extent of the library
    implemented_orders := lib[ 1 ];
    
    # number of loops of given order in the library
    NOL := lib[ 2 ];
    
    # testing arguments
    if (not n in Integers) or (not m in Integers) or not (n>0) or not (m>0) then
        Error("LOOPS: Both arguments must be positive integers.");
    fi;
    is_CC_p_case := false;
    if not n in implemented_orders then
        if not name="CC" then 
            Error("LOOPS: Order ", n, " not implemented.");
        else # CC loops, checking if n = p^2 or 2*p for odd prime p
            root := Sqrt( n );
            half := n/2;
            if ( IsInt( root ) and IsOddInt( root) and IsPrime( root ) ) or ( IsInt( half ) and IsOddInt( half ) and IsPrime( half ) ) then
                is_CC_p_case := true;
            else
                Error("LOOPS: Order ", n, " not implemented.");
            fi;
        fi;
    fi;
    if is_CC_p_case then # CC loops of order p^2 or 2*p
        if IsEvenInt( n ) and ( not m=1 ) then # 2*p
           Error("LOOPS: There is only 1 nonassociative CC-loop of order 2*p for an odd prime p.");
        fi;
        if (not IsEvenInt( n )) and (not m in [1..3]) then # p^2
            Error("LOOPS: There are only 3 nonassociative CC-loops of order p^2 for an odd prime p.");
        fi;
    else 
        pos_n := Position( implemented_orders, n );
        if NOL[ pos_n ] < m then 
            if NOL[ pos_n ] = 1 then
                Error("LOOPS: There is only ", NOL[ pos_n ], " ", name, " loop of order ", n, " in the library."); 
            else
                Error("LOOPS: There are only ", NOL[ pos_n ], " ", name, " loops of order ", n, " in the library."); 
            fi;
        fi; 
    fi;                                     
    
    #############################################################################
    ##  
    #F  PosInDB( m ) 
    ##  
    ##  Auxiliary function. Returns the position of the <m>th loop of order <n>
    ##  in the database. Note that <pos_n> is specified globally.
    PosInDB := function( m )
        local p;
        for p in [1 .. pos_n - 1] do
            m := m + NOL[ p ];
        od;
        return m;
    end;
    
    # activating the desired loop (treat cases separately below)
    
    # up to isomorphism
    if name = "left Bol" then 
        loop := LOOPS_ActivateLeftBolLoop( PosInDB( m ) );
        SetIsLeftBolLoop( loop, true );
    elif name = "right Bol" then
        loop := Opposite( LOOPS_ActivateLeftBolLoop( PosInDB( m ) ) );
        SetIsRightBolLoop( loop, true );
    elif name = "Moufang" then
        # renaming loops so that they agree with Goodaire's classification
        PG := List([1..243], i->());
        PG[16] :=   (2,5,3,4);
        PG[24] :=   (1,3,4)(2,5);
        PG[32] :=   (1,4,61,7,64,31,19,44,3,51,24,46,22,49,65,9,50,39,41,2,63,27,57,14,5,55,13,69,32,58,17,53,15)
            (6,71,28,36,30,47,18,42,26,60,21,59,35,52,25,40,23,43,29,56,20,66,8,70,33,67,38,54,16,62,37,11,68,34,45,10,48,12);
        PG[36] :=   (1,2);
        PG[40] :=   (1,2,5,3,4);
        PG[48] :=   (1,11,43,49,30,7,28,23,36,21,50,31,41,32,46,51,29,12,42,15)
            (2,25,24,35,22,8,39,5,6,38,16,19,17,37,34,33,4,47,13,20,10,40,48,14,3,26,45)
            (9,27,44);
        PG[56] :=   (1,2,4);
        PG[60] :=   (1,2);
        m_inv := m^Inverse( PG[ n ] );
        # activating the loop
        loop := LOOPS_ActivateMoufangLoop( PosInDB( m_inv ), n );
        SetIsMoufangLoop( loop, true );
    elif name = "Paige" then
        loop := LoopByCayleyTable( lib[ 3 ][ 1 ] ); #only one loop there at this point
        SetIsMoufangLoop( loop, true );
    elif name = "code" then
        loop := LibraryLoop( "Moufang", n, lib[ 3 ][ pos_n ][ m ] ); 
        SetIsCodeLoop( loop, true );
    elif name = "Steiner" then
        loop := LOOPS_ActivateSteinerLoop( PosInDB( m ), n );
        SetIsSteinerLoop( loop, true );
    elif name = "CC" then
        loop := LOOPS_ActivateCCLoop( n, m, is_CC_p_case );
        SetIsCCLoop( loop, true );
    elif name = "RCC" then
        loop := LOOPS_ActivateRCCLoop( n, m );
        SetIsRCCLoop( loop, true );
    elif name = "LCC" then
        loop := Opposite( LOOPS_ActivateRCCLoop( n, m ) );
        SetIsLCCLoop( loop, true );     
    elif name = "small" then
        loop := LoopByCayleyTable( LOOPS_DecodeCayleyTable( lib[ 3 ][ PosInDB( m ) ] ) );
    elif name = "interesting" then
        if [n,m] = [92,1] then # simple Bol loop of order 92
            g := Group((1,4)(2,9)(3,10)(6,11)(7,12)(13,21)(14,22)(15,24)(16,23)(17,30)(18,29)(19,31)(20,32)(33,35)(38,40), 
                (1,2,4,6,8,7,5,3)(9,13,25,18,10,14,26,17)(11,15,27,20,12,16,28,19)(21,30,38,34,23,31,40,35)(22,32,39,36,24,29,37,33));
            h := Normalizer( g, SylowSubgroup( g, 5) );
            g := Action( g, RightCosets( g, h ), OnRight );
            loop := LoopByRightSection(Union(Filtered(ConjugacyClasses(g),c->Size(c) in [1,15,80])));
        else             
            loop := LoopByCayleyTable( LOOPS_DecodeCayleyTable( lib[ 3 ][ PosInDB( m ) ][ 1 ] ) );
        fi;
        SetName( loop, lib[ 3 ][ PosInDB( m ) ][ 2 ] );
    elif name = "nilpotent" then
        loop := LOOPS_ActivateNilpotentLoop( lib[ 3 ][ PosInDB( m ) ] );
    elif name = "automorphic" then
        loop := LoopByCayleyTable( LOOPS_DecodeCayleyTable( lib[ 3 ][ PosInDB( m ) ] ) );
        SetIsAutomorphicLoop( loop, true );
    # up to isotopism        
    elif name = "itp small" then
        return LibraryLoop( "small", n, lib[ 3 ][ n-4 ][ m ] );
    fi;
    
    # setting the name
    if not name = "interesting" then
        SetName( loop, Concatenation( "<", name, " loop ", String( n ), "/", String( m ), ">" ) );
    fi;
    
    # returning the loop
    return loop;
end);

#############################################################################
##  READING LOOPS FROM THE LIBRARY - SPECIFIC CALLS
##  -------------------------------------------------------------------------

#############################################################################
##  
#F  LeftBolLoop( n, m ) 
#F  RightBolLoop( n, m )
#F  MoufangLoop( n, m ) 
#F  PaigeLoop( q )
#F  CodeLoop( n, m ) 
#F  SteinerLoop( n, m ) 
#F  CCLoop( n, m ) 
#F  SmallLoop( n, m ) 
#F  InterestingLoop( n, m ) 
#F  NilpotentLoop( n, m ) 
#F  AutomorphicLoop( n, m )
#F  ItpSmallLoop( n, m ) 
##    

InstallGlobalFunction( LeftBolLoop, function( n, m )
    return LibraryLoop( "left Bol", n, m );
end);

InstallGlobalFunction( RightBolLoop, function( n, m )
   return LibraryLoop( "right Bol", n, m );
end);

InstallGlobalFunction( MoufangLoop, function( n, m )
    return LibraryLoop( "Moufang", n, m );
end);

InstallGlobalFunction( PaigeLoop, function( q )
    # Paige loop over GF(q)
    if not q=2 then return Error("LOOPS: Only q=2 is implemented."); fi;
    return LibraryLoop( "Paige", 120, 1 );
end);

InstallGlobalFunction( CodeLoop, function( n, m )
    return LibraryLoop( "code", n, m );
end);

InstallGlobalFunction( SteinerLoop, function( n, m )
    return LibraryLoop( "Steiner", n, m );
end);

InstallGlobalFunction( CCLoop, function( n, m )
    return LibraryLoop( "CC", n, m );
end);

InstallGlobalFunction( ConjugacyClosedLoop, function( n, m )
    return LibraryLoop( "CC", n, m );
end);

InstallGlobalFunction( RCCLoop, function( n, m )
    return LibraryLoop( "RCC", n, m );
end);

InstallGlobalFunction( RightConjugacyClosedLoop, function( n, m )
    return LibraryLoop( "RCC", n, m );
end);

InstallGlobalFunction( LCCLoop, function( n, m )
    return LibraryLoop( "LCC", n, m );
end);

InstallGlobalFunction( LeftConjugacyClosedLoop, function( n, m )
    return LibraryLoop( "LCC", n, m );
end);


InstallGlobalFunction( SmallLoop, function( n, m )
    return LibraryLoop( "small", n, m );
end);

InstallGlobalFunction( InterestingLoop, function( n, m )
    return LibraryLoop( "interesting", n, m );
end);

InstallGlobalFunction( NilpotentLoop, function( n, m )
    return LibraryLoop( "nilpotent", n, m );
end);

InstallGlobalFunction( AutomorphicLoop, function( n, m )
    return LibraryLoop( "automorphic", n, m );
end);

InstallGlobalFunction( ItpSmallLoop, function( n, m )
    return LibraryLoop( "itp small", n, m );
end);
