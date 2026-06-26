import { useEffect, useState } from 'react';
import GameDetailClient from './GameDetailClient';

function NotFound() {
  const base = import.meta.env.BASE_URL.replace(/\/$/, '');
  return (
    <div className="flex flex-col items-center justify-center min-h-[60vh] text-center px-4">
      <p className="font-display text-8xl font-black text-zinc-800 mb-4">404</p>
      <p className="text-xl text-zinc-400 mb-6">Esta página no existe.</p>
      <a href={`${base}/`} className="text-amber-400 hover:underline">
        ← Volver al inicio
      </a>
    </div>
  );
}

export default function GameFromUrl() {
  const [slug, setSlug] = useState<string | null | undefined>(undefined);

  useEffect(() => {
    const base = import.meta.env.BASE_URL.replace(/\/$/, '');
    const pathname = window.location.pathname;
    const prefix = `${base}/games/`;
    if (pathname.startsWith(prefix)) {
      const s = pathname.slice(prefix.length).replace(/\/$/, '');
      setSlug(s || null);
    } else {
      setSlug(null);
    }
  }, []);

  if (slug === undefined) return null;
  if (!slug) return <NotFound />;
  return <GameDetailClient slug={slug} />;
}
