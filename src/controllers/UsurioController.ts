import { app } from "../server";
import { UsuarioRepository } from "../repositories/UsuarioRepository";

export function UsuarioController() {
  const repository = new UsuarioRepository();

  app.get("/usuarios", (req, res) => {
    const { nome } = req.query;

    if (nome) {
      const usuario = repository.buscarPorNome(nome as string);
      if (!usuario) return res.status(404).json({ erro: "Usuário não encontrado" });
      return res.json(usuario);
    }

    res.json(repository.listar());
  });

  app.get("/usuarios/:id", (req, res) => {
    const id = parseInt(req.params.id);
    const usuario = repository.buscarPorId(id);
    if (!usuario) return res.status(404).json({ erro: "Usuário não encontrado" });
    res.json(usuario    );
  });

  app.post("/usuarios", (req, res) => {
    try {
      const { nome, email } = req.body;

      if (!nome || nome.trim().length === 0) throw new Error("Nome é obrigatório");
      if (!email || !email.includes("@")) throw new Error("Email inválido");

      const usuario = repository.salvar({ nome, email });
      res.status(201).json(usuario);
    } catch (err) {
      const mensagem = err instanceof Error ? err.message : "Erro interno";
      res.status(400).json({ erro: mensagem });
    }
  });
}
