("Esercizio_1")
int test(int * ptr, int x){
    if (x >= 0)
    {
        x = x - 1;
    *ptr = x*x + puzzle (ptr + 1, x);
    return 0;
    }
    else
        return 1;
}

test:
//Ricorda ptr sarà in a0 e x in a1 ALL INIZIO
blt a1, zerp, .end
addi sp, sp, -20        // Avrò bisogno di spazio sullo stack
                        // per ra , sp , ptr e x
sd ra, 0(sp)            // Salvo return address sullo stack
sd a0, 8(sp)            // Salvo ptr
addi a1, a1, -1         // x = x - 1
mul t0, a1, a1          // t0 = x*x
sw t0, 16(sp)           // salvo x*x sullo stack
addi a0, a0, 4          // ptr = ptr + 1
jal ra, puzzle          // chiamo la funzione puzzle che leggera
                        // i propri input da a0 e a1
                        // Nota, ora hai il valore di puzzle in a0 mentre i dati nella funzione chaimaante
                        // sono nello stack
lw t0, 16(sp)           // Ricarico t0 (x*x) da stack
ld t1, 8(sp)            // Ricarico ptr (che prima era in a0 ma ora c'è puzzle allora metto in t1)
                        // da stack
ld ra, 0(sp)            // Ricarico il return address di test da stack
add a0, a0, t0          // a0 = a0 + t0 ovvero puzzle + x*x
sw a0, 0(t1)            // Salvo a0 ^^ nel indirizzo dato da *ptr
addi sp, sp, 20         // Dealloco spazio sullo stack
addi a0, zero, 0        // Ora devo ritornare 0, allora lo inserisco in a0
jalr zero, 0(ra)

end:
addi a0, zero, 1        // Return 1
jalr zero, 0(ra)        // Salto all indirizzo di ritorno

("Esercizio_2")
    # 2 KiB allora l indirizzo è di 11 bit
    # Due blocchi a due vie e quindi l indice è 1 bit.
    # 32 byte per blocco ovvero 2^5 byte per blocco quindi l offset è di 5 bit.
    # Il tag è quindi 5 bit.

    # Quindi l indirizzo è formato da 
    # TAG - INDICE - OFFSET
    # 5   -   1    -   5
                                        |   Blocco 0.a|   Blocco 0.b|   Blocco 1.a|   Blocco 1.b|
    ---------------------------------------------------------------------------------------------
        indirizzo:      risultato:         | V |    T    | V |    T    | V |    T    | V |    T    |
    ---------------------------------------------------------------------------------------------
    0                                      | Y |  11000  | Y |  10100  | X |  00000  | V |  01010  |
    ---------------------------------------------------------------------------------------------
    1  111 1101 0110      MISS             | Y |  11111  |   |         |   |         |   |         |
    ---------------------------------------------------------------------------------------------
    2  101 1101 0100      MISS             |   |         | Y |  10111  |   |         |   |         |
    ---------------------------------------------------------------------------------------------
    3  011 1101 1001      MISS             | Y |  01111  |   |         |   |         |   |         |
    ---------------------------------------------------------------------------------------------
    4  100 0110 1010      MISS             |   |         |   |         | Y |  10001  |   |         |
    ---------------------------------------------------------------------------------------------
    5  001 0101 0010      MISS             |   |         | Y |  00101  |   |         |   |         |
    ---------------------------------------------------------------------------------------------
    6  001 1110 0110      MISS             |   |         |   |         |   |         | Y |  00111  |


("Esercizio_3")
    1)
    T(N) = T(4N/3)+ Θ(N^2)
    APPLICABILE:
        No, perchè b = 3/4 < 1

    2)
    T(N) = 4T(N/2)+ Θ(N^2)
    APPLICABILE:
        b = 2 > 1
        a = 1 >= 1
        f(N) è asintoticamente positiva..
        Si può applicare
        Posso applicare il secondo caso...
        T(N) = Θ(N^2 logN)

    3)
    T(N) = 2T (N-1/3)+ Θ(logN)
    APPLICABILE:
        No perchè non è nella forma standard...

("Esercizio_5")
    1)
        Se N = 1 o N = 2 allora ogni thread eseguirà una delle due sezioni.

    2) 
        Per M < 10 allora ogni thread eseguirà un iterazione del for in
        modo statico, ovvero ogni thread eseguirà una iterazione del for.

    3)
        Tempo sequenziale: 1100 unità
        Tempo parallelo massimo con N = 2 e M = 10
        max(100,100) = 100
        Speed_up: 1100/100 = 11
    4)
    


Domande_di_teoria:
    ("Domanda_1")
        # Descrivere l algoritmo randomico che seleziona l i-esimo minor elemento in un array. Come funziona? 
        # A che classe di algoritmi appartiene? Quale è la complessità? Esiste una versione non randomica?
    ("Risposta_2")
        # 1)Vedere i lucidi lecture8-Select-ith.pdf nella parte che descrive RAND-SELECT a partire da pagina 10.
        # 2)L algoritmo è un algoritmo randomico di tipo Las Vegas che ricade anche fra gli algoritmi di tipo 
        # “Divide et Impera”/“divide-and-conquer”.
        # 3)L expected running time dell algoritmo è lineare. Worst case running time è quadratico.
        # 4) Si esiste, vedere gli stessi lucidi a partire da pagina 26.

    ("Domanda_2")
        # Descrivere la “CUDA thread hierarchy”?
    ("Risposta_2")
        # I thread sono organizzati in blocchi, i blocchi in griglie.
        # I blocchi e le griglie possono essere organizzati in dimensioni fino a 3.
        # Ogni SM (streaming multiprocessor) esegui thread di in singolo blocco in gruppi da 32 chiamati warp.

    ("Domanda_3")
        # Che tipo di parallelismo principalmente considera CUDA?
    ("Risposta_3")
        # Il parallelismo base che può essere estratto da un programma scritto in CUDA è di tipo SIMD, 
        # le sezioni parallele infatti vengono semplicemente eseguite da piu thread contemporaneamente,
        # ogni thread però può accedere a dati diversi.
        # Si puo anche implementare un parallelismo di tipo MIMD attraverso l uso di streams.

    ("Domanda_4")
        # Descrivere brevemente la gerarchia delle memorie secondo il modello di 
        # programmazione di CUDA?
    ("Risposta_4")
        # La gerarchia delle memorie è composta da:
        # 1) Ogni thread ha a disposizione una memoria locale composta da registri.
        # 2) Ogni blocco ha a disposizione una memoria condivisa.
        # 3) Memoria globale (GPU DRAM).
        # E importante notare che l host puo accedere solo alla memoria globale.
