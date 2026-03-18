export interface Categoria {
    id?: number;
    nome: string;
    descricao: string;
}

export interface metodo_pagamento{
    id?: number;
    nome: string;
}

export interface Fornecedor {
    id?: number;
    
}



export interface Produto {
    id?: number;
    nome: string;
    preco: number;
    descricao: string;
    estoque: number;
}