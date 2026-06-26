import { useEffect, useState } from 'react';
import { getAllGames } from '../lib/db';
import type { GameSummary } from '../lib/types';
import GameCard from './GameCard';

export default function GamesGrid() {
  const [games, setGames] = useState<GameSummary[] | null>(null);

  useEffect(() => {
    getAllGames().then(setGames);
  }, []);

  return (
    <section id="juegos" className="max-w-7xl mx-auto px-4 sm:px-6 pb-20">
      <h2 className="font-display text-2xl font-bold text-zinc-200 mb-8">
        Juegos{' '}
        {games !== null && (
          <span className="text-zinc-500 font-normal text-lg">({games.length})</span>
        )}
      </h2>

      {games === null ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {[0, 1, 2].map(i => (
            <div key={i} className="h-64 rounded-2xl bg-zinc-900 animate-pulse border border-zinc-800" />
          ))}
        </div>
      ) : games.length === 0 ? (
        <div className="text-center py-20 text-zinc-600">
          <p className="text-5xl mb-4">🎲</p>
          <p className="text-lg">No hay juegos todavía.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {games.map((game, i) => (
            <GameCard
              key={game.id}
              slug={game.slug}
              title={game.title}
              tagline={game.tagline}
              coverImage={game.coverImage ?? undefined}
              players={game.players}
              duration={game.duration}
              difficulty={game.difficulty}
              theme={game.theme}
              index={i}
            />
          ))}
        </div>
      )}
    </section>
  );
}
