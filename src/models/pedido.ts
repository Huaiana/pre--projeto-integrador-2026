export interface Pedido {
    id?: number;
    usuario_id: number;
    funcionario_id: number;
    metodo_pagamento_id: number;
    valor_total: number;
    data_pedido: Date;
    status: string;
}

