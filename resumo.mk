Contexto do exercício

Três tarefas foram dadas, cada uma representando um programa simples em C, executado em um sistema operacional com controle de estados de tarefas.

Premissas:
Item	Descrição	Tempo (ticks)
E/S (entrada/saída)	printf, fprintf, fopen, fclose	2
Instrução while (count < 5)	Execução de CPU	1
Troca de contexto (SO)	Tempo de troca entre tarefas	1
Escalonamento	Tempo do escalonador	0
Mudança de estado	Tempo de mudança (pr, su, ex...)	0
Estados possíveis
Código	Significado
no	novo
pr	pronto
ex	executando
su	suspenso (aguardando E/S)
fi	finalizado
🧩 Códigos das tarefas
Tarefa 1 (t1)
FILE * fp = fopen("exemplo", "w+");
int count = 1;
while (count < 5) {
  fprintf(fp, "%d ", count);
  printf("%d\n", count);
  count++;
}
fclose(fp);

Tarefa 2 (t2)
FILE * fp = fopen("exemplo", "w+");
int count = 1;
while (count < 5) {
  fprintf(fp, "%d ", count);
  count++;
}
fclose(fp);

Tarefa 3 (t3)
int count = 1;
while (count < 5) {
  count++;
}

⚙️ Atividade 1 — Quantum = 1 tick
🔸 Tabela de execução (fatia de tempo = 1 tick)
Tick	SO	t1	t2	t3	Fila de pr
01	ex	--	--	--	--
02	ex	no	--	--	--
03	ex	pr	no	--	t1
04	ex	--	pr	no	t1, t2
05	ex t1	--	--	pr	t2, t3
06	--	ex linha 1	--	--	t2, t3
07	ex t2	su 1	--	--	t2, t3
08	--	su 2	ex linha 1	--	t3
09	ex t3	pr	su 1	--	t1
10	--	--	su 2	ex linha 1	t1
11	ex t1	ex linha 2	su 2	su 1	t3
12	--	su 3	su 2	ex linha 2	t1
13	ex t3	su 3	su 2	ex linha 3	t1
14	--	su 2	su 1	fi	t1
15	ex t1	ex linha 3	su 2	fi	t2
16	--	su 1	ex linha 2	fi	t1
17	ex t2	su 2	su 3	fi	t1
18	--	su 1	fi	fi	t1
19	ex t1	ex linha 4	fi	fi	--
20	--	fi	fi	fi	--
🔍 Observações:

O quantum de 1 tick causa muitas trocas de contexto.

As tarefas com E/S (t1 e t2) ficam frequentemente suspensas.

t3, mesmo sendo curta, é interrompida várias vezes, o que aumenta o tempo total de conclusão.

⚙️ Atividade 2 — Quantum = 10 ticks
🔸 Tabela de execução (fatia de tempo = 10 ticks)
Tick	SO	t1	t2	t3	Fila de pr
01	ex	--	--	--	--
02	ex	no	--	--	--
03	ex	pr	no	--	t1
04	ex	--	pr	no	t1, t2
05	ex t1	--	--	pr	t2, t3
06	--	ex linha 1	--	--	t2, t3
07	ex t2	su 1	--	--	t2, t3
08	--	su 2	ex linha 1	--	t3
09	ex t3	pr	su 1	--	t1
10	--	--	su 2	ex linha 1	t1
11	ex t1	ex linha 2	su 2	su 1	t3
12	--	su 2	ex linha 1	su 1	t3
13	--	su 2	ex linha 2	su 1	t3
14	--	su 2	su 1	su 1	t3
15	ex t3	su 2	su 1	ex linha 1	--
16	--	su 2	su 1	ex linha 2	--
17	--	su 2	su 1	ex linha 3	--
18	--	su 2	su 1	ex linha 4	--
19	--	su 2	su 1	fi	--
20	ex t1	ex linha 3	su 2	fi	t2
🔍 Observações:

Com quantum maior, o sistema realiza menos trocas de contexto.

t3 consegue executar completamente sem ser interrompida.

Há menos overhead do SO e maior aproveitamento da CPU.

🧩 Atividade 3 — Avaliação do comportamento de t3
Aspecto	Quantum = 1 tick	Quantum = 10 ticks
Tempo de CPU	Interrompido várias vezes	Executa direto até o fim
Trocas de contexto	Muitas (a cada tick)	Poucas (quase nenhuma para t3)
Desempenho	Ruim — overhead alto	Ótimo — execução contínua
Conclusão	t3 termina tarde, apesar de ser leve	t3 termina rápido, sem preempção
🧠 Conclusão geral:

A tarefa t3, por não realizar operações de E/S e exigir pouco tempo de CPU, é favorecida por quantuns maiores.
Com fatia de tempo de 1 tick, o SO interrompe constantemente, gerando alto overhead e atrasando sua finalização.
Já com quantum de 10 ticks, a tarefa executa de forma contínua, finalizando rapidamente e reduzindo o custo de trocas de contexto.

