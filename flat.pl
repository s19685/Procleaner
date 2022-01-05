room(livingroom).
room(bedrooom).
room(balcony).

object(trash1).
object(trash2).
object(trash3).
object(chair1).
object(chair2).
object(chair3).
object(chair4).
object(table).
object(lamp1).
object(lamp2).
object(bed).
object(wastebin).
object(door).

trash(trash1).
trash(trash2).
trash(trash3).

chair(chair1).
chair(chair2).
chair(chair3).
chair(chair4).

connection(livingroom,bedroom).
connection(livingroom,balcony).
connection(livingroom,outside).

is_connection(X,Y):-
    connection(X,Y),!;
    connection(Y,X).

all_rooms([livingroom, bedroom, balcony]).


sit_anywhere:-
    all_rooms(AllRooms),
	try_sit(AllRooms).

try_sit([Room|_]):-
    is_somethign_to_sit_in_room(Room, SomethingToSeat),
	  go_to(Room),
    sit(SomethingToSeat),!.
try_sit([Room|Rooms]):-
	\+ is_somethign_to_sit_in_room(Room, _),
	try_sit([Rooms]).

sit(X):-
	whereiam(Room),
	in_room(Room, X),
	can_i_sit(X),
	write('Usiadles na: '),
  	write(X).

can_i_sit(X):-
    chair(X),!;
    X = bed.

is_somethign_to_sit_in_room(Room, Item):-
    all_items_in_room(Room, Items),
    member(Item, Items),
    can_i_sit(Item),!.





clean_up:-
    all_rooms(AllRooms),
	clean_rooms(AllRooms).

clean_rooms([]).
clean_rooms([Room|Rooms]):-
    go_to(Room),
    clean_room(Room),!,
    clean_rooms(Rooms).

clean_room(Room):-is_clean(Room).
clean_room(Room):-
    all_rubbish_in_room(Room, Trashes),
    clean_up_rubbish(Trashes).

is_clean(Room):- all_rubbish_in_room(Room, []).

all_rubbish_in_room(Room, X):-
    all_rubbish_in_room(Room, [], X).
all_rubbish_in_room(Room, Acc, Res):-
    trash(Trash),
    in_room(Room, Trash),
    \+ member(Trash, Acc), !,
    all_rubbish_in_room(Room, [Trash|Acc], Res).
all_rubbish_in_room(_, Res, Res).

in_room(Room, Item):-
    all_items_in_room(Room, Items),
    member(Item, Items).

clean_up_rubbish([]).
clean_up_rubbish([Trash|Rubbish]):-
    throw_out(Trash),
    clean_up_rubbish(Rubbish).

throw_out(Trash):-
    whereiam(Room),
    write("przed sprzataniem w  "),
    write(Room),
    write(" sa nastepujace przedmioty"),
    all_items_in_room(Room, Items),
    write(Items),
    nl,
    member(Trash, Items),
    removeAll(Trash, Items, ItemsNew),
    write("po sprzataniu"),
    write(ItemsNew),
    nl,
    retractall(all_items_in_room(Room, _)),
    assert(all_items_in_room(Room, ItemsNew)),
    clean_and_back(Trash, Room),
    all_items_in_room(Room, Items3),
    write(Items3),
    nl,!.

clean_and_back(Trash, Room):-
    write("Ide poszukac smietnika"),
    nl,
    look_for_bin(Room2),
    go_to(Room2),
    write('Wyrzucilem smiecia '),
    write(Trash),
    write(" w "),
    write(Room2),
    nl,
    go_to(Room).

look_for_bin(Room):-
    all_items_in_room(Room, Items),
    member(wastebin, Items),!.


:- dynamic whereiam/1.
whereiam(outside).

:- dynamic all_items_in_room/2.
all_items_in_room(balcony, [trash1]).
all_items_in_room(livingroom, [trash2, chair1, chair2, chair3, chair4, lamp1, wastebin, table]).
all_items_in_room(bedroom, [lamp2, trash3, bed]).

go_to(X) :-
    whereiam(X),
    write('Juz jestem w '),
    write(X),
    nl.
go_to(To) :-
    whereiam(From),
    is_connection(From, To),
    retractall(whereiam(_)),
    assert(whereiam(To)),
    write('Wszedlem do: '),
    write(To),
    nl.
go_to(To) :-
    whereiam(From),
    is_connection(From, Throught),
    go_to(Throught),
    go_to(To),!.

removeAll(_, [], []).
removeAll(X, [X|T], L):- removeAll(X, T, L), !.
removeAll(X, [H|T], [H|L]):- removeAll(X, T, L ).

%DEMO Commands

% whereiam(X).

% go_to(balcony),whereiam(X).

% go_to(bedroom),sit(X).

% sit_anywhere.

% go_to(balcony),throw_out(X).

% clean_up.
