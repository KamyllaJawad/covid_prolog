nivel(gravissimo).
nivel(grave).
nivel(medio).
nivel(leve).

situacao(Paciente, leve) :-
    parametro(Paciente, temp, Valor), Valor>35, Valor<37;
    parametro(Paciente, freqcard, Valor), Valor<100;
    parametro(Paciente, freqresp, Valor), Valor=<18;
    parametro(Paciente, pasist, Valor), Valor>100;
    parametro(Paciente, sao2, Valor), Valor>=95;
    parametro(Paciente, dispneia, Valor), (Valor="n"; Valor="N");
    parametro(Paciente, idade, Valor), Valor<60;
    parametro(Paciente, comorbidades, Valor), Valor=:=0.

situacao(Paciente, medio) :-
    parametro(Paciente, temp, Valor), Valor=<35;
    parametro(Paciente, temp, Valor), Valor>=37, Valor=<39;
    parametro(Paciente, freqcard, Valor), Valor>=100;
    parametro(Paciente, freqresp, Valor), Valor>=19, Valor=<30;
    parametro(Paciente, idade, Valor), Valor>=60, Valor=<79;
    parametro(Paciente, comorbidades, Valor), Valor=:=1.

situacao(Paciente, grave) :-
    parametro(Paciente, temp, Valor), Valor>=39;
    parametro(Paciente, idade, Valor), Valor>=80;
    parametro(Paciente, pasist, Valor), Valor>=90,Valor=<100;
    parametro(Paciente, comorbidades, Valor), Valor>=2.

situacao(Paciente, gravissimo) :-
    parametro(Paciente, freqresp, Valor), Valor>30;
    parametro(Paciente, pasist, Valor), Valor<90;
    parametro(Paciente, sao2, Valor), Valor<95;
    parametro(Paciente, dispneia, Valor), (Valor="s";Valor="S").

:- dynamic parametro/3.

covid :- carrega('covid.bd'),
    format('~n *** Verificação de Situação do Paciente com Covid-19 ***~n~n'),
    repeat,
    pergunta(Nome),
    resposta(Nome),
    continua(R),
    R=n,
    !,
    salva(parametro, 'covid.bd').

carrega(A) :-
    exists_file(A),
    consult(A)
    ;
    true.

pergunta(Nome) :-
    format('~nNome do paciente:  '),
    gets(Nome),

    format('~nIdade:  '),
    gets(Idade),
    asserta(parametro(Nome, idade, Idade)),

    format('~nNúmero de comorbidades: '),
    gets(Comorbidades),
    asserta(parametro(Nome, comorbidades, Comorbidades)),

    format('~nTemperatura:  '),
    gets(Temperatura),
    asserta(parametro(Nome, temp, Temperatura)),

    format('~nFrequência cardíaca:  '),
    gets(FreqCard),
    asserta(parametro(Nome, freqcard, FreqCard)),

    format('~ Frequência respiratória:  '),
    gets(FreqResp),
    asserta(parametro(Nome, freqresp, FreqResp)),

    format('~nPA Sistólica:  '),
    gets(PaSist),
    asserta(parametro(Nome, pasist, PaSist)),

    format('~nSaturação:  '),
    gets(Saturacao),
    asserta(parametro(Nome, sao2, Saturacao)),

    format('~nDispnéia:(s/n)  '),
    gets(Dispneia),
    asserta(parametro(Nome, dispneia, Dispneia)).


resposta(Nome) :-
    situacao(Nome, X),
    !,
    format('~n O nível da situação de ~w é ~w.~n', [Nome, X]).

continua(R) :-
    format('~nInformar novo paciente:(s/n)'),
    get_char(R),
    get_char('\n').

gets(S) :-
    read_line_to_codes(user_input,C),
    name(S,C).

salva(P,A) :-
    tell(A),
    listing(P),
    told.

