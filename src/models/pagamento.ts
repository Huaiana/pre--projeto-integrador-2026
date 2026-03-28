export interface Pagamento {
id?: number;
id_pedido: number;
id_metodo_pagamento: number;
valor_pago: number;
data_hora: Date;
status_transacao: string;
}
