Per implementare gli IF ELSE bisognava creare una struttura dati, perchè non c'è modo di eseguire uno statement o l'altro,
l'unico modo è eseguirli entrambi e in base alla "logiceq" (con logiceq intendo tipo "10 lt 20") e in base al risultato (0 se è false, 1 se è true)
fare in modo che venisse eseguito uno o l'altro.
Quindi ho fatto una struct con action che è l'azione, val1 e val2 che son i due valori,nel caso di un print val1 è niente...
Quando c'è un'equazione logica viene chiamata la produzione neststmt dove valuta se è un assegnamento, un print o un'altra equazione logica
In ogni caso ritorna un oggetto di tipo act, ovvero un'azione, l'oggetto conterrà come act->action il nome dell'azione, e in base al nome
dell'azione viene chiamato il corrispondente metodo che va a printare o assegnare i corrispondenti valori act->val1 act->val2
