:- dynamic docente/5.  %nome disciplina, sexo, substituto, departamento, nome docente
:- dynamic disciplina/3. %nome disciplina, nome docente, departamento

menu :-  repeat,
    format('~n~n~n---MENU DE OPÇÕES---~n'),
    format('~n1) Consultar docente'),
    format('~n2) Consultar disciplina'),
    format('~n3) Exibir todos os docentes'),
    format('~n4) Exibir todas as disciplinas'),
    format('~n5) Excluir docente'),
    format('~n0) Sair do programa'),
    format('~nOpção: '),
    gets(Op),
    if(Op=:=1, docente, format('')),
    if(Op=:=2, disciplina, format('')),
    if(Op=:=3, exibeDoc, format('')),
    if(Op=:=4, exibeDisc, format('')),
    if(Op=:=5, excluir, format('')),
    Op=0,
    !,
    write("passou").

docente :- carrega('docente.bd'),
    carrega('disciplina.bd'),
    format('~n~n---Sistema de docentes---~n'),
    pergunta1P(D),
    pergunta2P(S),
    pergunta3P(Sub),
    pergunta4P(Dep),
    respondeP(D,S,Sub,Dep),
    salva(docente, 'docente.bd'),
    salva(disciplina, 'disciplina.bd'), !.

disciplina :- carrega('disciplina.bd'),
    carrega('docente.bd'),
    format('~n~n---Sistema de disciplinas---~n'),
    pergunta1D(D),
    pergunta2D(N),
    pergunta3D(Dep),
    respondeD(D,N,Dep),
    salva(disciplina, 'disciplina.bd'), !.


%regras para professores (docentes)
pergunta1P(D) :- format('~n-Docente-~n'),
    format('1) Qual o nome da disciplina que o docente leciona?~nR: '),
    gets(D).

pergunta2P(S) :- format('~n2) Qual o sexo do docente? [F/M]~nR: '),
    gets(S).

pergunta3P(Sub) :- format('~n3) O docente é substituto? [s/n]~nR: '),
    get_char(Sub), get_char('\n').

pergunta4P(Dep) :- format('~n4) Qual o departamento do docente?~nR: '),
    gets(Dep).

respondeP(D,S,Sub,Dep) :- docente(D,S,Sub,Dep,N), !, format('~n~nSISTEMA: Docente encontrado!~n-Docente: ~w.~n-Disciplina: ~w.~n', [N,D]).

respondeP(D,S,Sub,Dep) :- format('~n~nSISTEMA: Docente não encontrado!~nDeseja gravar a resposta na base de dados do sistema? [s/n]~nR: '),
    get_char(R), get_char('\n'),
    if(R=s, nomeP(D,S,Sub,Dep), write('Dados apagados\n\n')).

nomeP(D,S,Sub,Dep) :-  format('~nQual o nome do docente?~nR: '),
    gets(N),
    asserta(docente(D,S,Sub,Dep,N)),
    asserta(disciplina(D,N,Dep)).


%regras para disciplinas
pergunta1D(D) :- format('~n-Disciplina-~n'),
    format('1) Qual o nome da disciplina?~nR: '),
    gets(D).

pergunta2D(N) :- format('~n2) Qual o nome do docente?~nR: '),
    gets(N).

pergunta3D(Dep) :- format('~n3) Qual o departamento da disciplina?~nR: '),
    gets(Dep).

respondeD(D,N,Dep) :- disciplina(D,N,Dep), !, format('~n~nSISTEMA: Disciplina encontrada!~n-Docente: ~w.~n-Disciplina: ~w.~n', [N,D]).

respondeD(D,N,Dep) :- format('~n~nSISTEMA: Disciplina não encontrada!~nDeseja gravar a resposta na base de dados do sistema? [s/n]~nR: '),
    get_char(R), get_char('\n'), write('\n-Dados salvos!-\n'),
    if(R=s, asserta(disciplina(D,N,Dep)), write('Dados apagados\n\n')).


%regras para excluir docente e disciplina
excluir :- write('\nDigite o nome do docente a ser excluido\n'),
    gets(X),
    if(analise(X), remover(X), write('Docente não encontrado\n')),
    salva(docente, 'docente.bd'),
    salva(disciplina, 'disciplina.bd').

analise(X) :- docente(_,_,_,_,X),
    disciplina(_,X,_).

remover(X) :- write('\nDocente apagado e disciplina desvinculada!\n'),
    retract(docente(_,_,_,_,X)),
    retract(disciplina(_,X,_)).


%regras para exibir docentes e disciplinas
exibeDoc :- format('~n~n---Mostrando docentes---'),
    forall(docente(D,S,_,Dep,N),
    format('~n-Docente: ~w~n-Disciplina: ~w~n-Sexo: ~w~nDepartamento: ~w~n',[N,D,S,Dep])).

exibeDisc :- format('~n~n---Mostrando disciplinas---'),
    forall(disciplina(D,N,Dep),
    format('~n-Disciplina: ~w~n-Docente: ~w~n-Departamento: ~w~n',[D,N,Dep])).


%regras genéricas
if(Condition,Then,_) :- Condition, !, Then.
if(_,_,Else) :- Else.

continua(R) :- format('~nDeseja continuar? [s/n]~nR: '), get_char(R), get_char('\n').
salva(P,A) :- tell(A), listing(P), told.
carrega(A) :- exists_file(A), consult(A); true.
gets(S) :- read_line_to_codes(user_input, D), name(S,D).
