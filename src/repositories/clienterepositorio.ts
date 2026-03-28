import db from "../database/database";
import { Usuario } from "../models/Usuario";

export class UsuarioRepository {
  salvar(usuario: Usuario): Usuario {
    const resultado = db
      .prepare("INSERT INTO usuarios (nome, email) VALUES (?, ?)")
      .run(usuario.nome, usuario.email);

    return { id: Number(resultado.lastInsertRowid), nome: usuario.nome, email: usuario.email };
  }

  listar(): Usuario[] {
    return db.prepare("SELECT * FROM usuarios").all() as Usuario[];
  }

  buscarPorId(id: number): Usuario | null {
    return (db.prepare("SELECT * FROM usuarios WHERE id = ?").get(id) as Usuario) ?? null;
  }

  buscarPorNome(nome: string): Usuario | null {
    return (db.prepare("SELECT * FROM usuarios WHERE nome LIKE ?").get(`%${nome}%`) as Usuario) ?? null;
  }
}
