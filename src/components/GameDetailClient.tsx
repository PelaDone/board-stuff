import { useEffect, useState } from 'react';
import { marked } from 'marked';
import { getGameBySlug } from '../lib/db';
import type { GameDetail, Difficulty } from '../lib/types';
import CharacterCard from './CharacterCard';
import ChangeHistory from './ChangeHistory';
import { UsersIcon, ClockIcon, ArrowLeftIcon } from './icons';

type Tab = 'reglas' | 'personajes' | 'historial';

const difficultyColor: Record<Difficulty, string> = {
  'Fácil':      'bg-emerald-500/20 text-emerald-300',
  'Intermedio': 'bg-amber-500/20 text-amber-300',
  'Difícil':    'bg-orange-500/20 text-orange-300',
  'Experto':    'bg-red-500/20 text-red-300',
};

const tabs: { id: Tab; label: string }[] = [
  { id: 'reglas',     label: 'Reglas' },
  { id: 'personajes', label: 'Personajes' },
  { id: 'historial',  label: 'Historial' },
];

function LoadingSkeleton() {
  return (
    <div className="animate-pulse">
      <div className="h-64 bg-zinc-900" />
      <div className="h-12 bg-zinc-950 border-b border-zinc-800" />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-10 space-y-4">
        <div className="h-6 bg-zinc-800 rounded w-1/3" />
        <div className="h-4 bg-zinc-800 rounded w-full" />
        <div className="h-4 bg-zinc-800 rounded w-5/6" />
        <div className="h-4 bg-zinc-800 rounded w-4/5" />
        <div className="h-4 bg-zinc-800 rounded w-full mt-6" />
        <div className="h-4 bg-zinc-800 rounded w-3/4" />
      </div>
    </div>
  );
}

export default function GameDetailClient({ slug }: { slug: string }) {
  const [game, setGame] = useState<GameDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [notFound, setNotFound] = useState(false);
  const [activeTab, setActiveTab] = useState<Tab>('reglas');
  const [rulesHtml, setRulesHtml] = useState('');

  const base = import.meta.env.BASE_URL.replace(/\/$/, '');

  useEffect(() => {
    setLoading(true);
    setNotFound(false);
    setActiveTab('reglas');

    getGameBySlug(slug).then(async g => {
      if (!g) {
        setNotFound(true);
        setLoading(false);
        document.title = 'No encontrado · Board Stuff';
        return;
      }
      const html = String(await marked.parse(g.rules));
      setRulesHtml(html);
      setGame(g);
      setLoading(false);
      document.title = `${g.title} · Board Stuff`;
    });
  }, [slug]);

  if (loading) return <LoadingSkeleton />;

  if (notFound) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] text-center px-4">
        <p className="font-display text-8xl font-black text-zinc-800 mb-4">404</p>
        <p className="text-xl text-zinc-400 mb-6">Este juego no existe.</p>
        <a href={`${base}/`} className="text-amber-400 hover:underline">
          ← Volver al inicio
        </a>
      </div>
    );
  }

  const { title, tagline, coverImage, players, duration, difficulty, theme, characters, changelog } = game!;

  return (
    <>
      {/* Hero */}
      <div
        className="relative min-h-[40vh] flex items-end overflow-hidden"
        style={{ backgroundColor: theme.bg }}
      >
        {coverImage ? (
          <>
            <img
              src={coverImage}
              alt={title}
              decoding="async"
              loading="eager"
              className="absolute inset-0 w-full h-full object-contain opacity-25"
            />
            <div
              className="absolute inset-0"
              style={{ background: `linear-gradient(to top, ${theme.bg} 0%, transparent 60%)` }}
            />
          </>
        ) : (
          <div className="absolute inset-0 flex items-center justify-center overflow-hidden pointer-events-none select-none">
            <span
              className="font-display font-black tracking-tight whitespace-nowrap"
              style={{ color: theme.primary, opacity: 0.07, fontSize: '20vw' }}
            >
              {title}
            </span>
          </div>
        )}

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 pb-10 pt-20 w-full">
          <a
            href={`${base}/`}
            className="inline-flex items-center gap-2 text-sm mb-6 opacity-60 hover:opacity-100 transition-opacity"
            style={{ color: theme.primary }}
          >
            <ArrowLeftIcon className="w-4 h-4" /> Todos los juegos
          </a>
          <h1
            className="font-display text-5xl sm:text-7xl font-black tracking-tight mb-3"
            style={{ color: theme.primary }}
          >
            {title}
          </h1>
          <p className="text-lg sm:text-xl mb-6 max-w-2xl" style={{ color: theme.secondary }}>
            {tagline}
          </p>
          <div className="flex flex-wrap items-center gap-3">
            <span className="badge bg-zinc-800/80 text-zinc-300 gap-1">
              <UsersIcon className="w-3.5 h-3.5" /> {players}
            </span>
            <span className="badge bg-zinc-800/80 text-zinc-300 gap-1">
              <ClockIcon className="w-3.5 h-3.5" /> {duration}
            </span>
            <span className={`badge ${difficultyColor[difficulty]}`}>{difficulty}</span>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="sticky top-16 z-40 border-b border-zinc-800 bg-zinc-950/90 backdrop-blur-md">
        <div className="max-w-7xl mx-auto px-4 sm:px-6">
          <nav className="flex gap-1 overflow-x-auto">
            {tabs.map(tab => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex-shrink-0 px-4 py-3 text-sm font-medium border-b-2 transition-colors ${
                  activeTab === tab.id
                    ? 'text-white'
                    : 'text-zinc-400 border-transparent hover:text-zinc-100'
                }`}
                style={
                  activeTab === tab.id
                    ? { borderBottomColor: theme.accent, color: 'white' }
                    : { borderBottomColor: 'transparent' }
                }
              >
                {tab.label}
              </button>
            ))}
          </nav>
        </div>
      </div>

      {/* Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-10">
        {activeTab === 'reglas' && (
          <div
            className="prose prose-invert prose-zinc max-w-none
              prose-headings:font-display prose-headings:tracking-tight
              prose-h2:text-2xl prose-h2:border-b prose-h2:border-zinc-800 prose-h2:pb-2
              prose-a:text-amber-400 prose-a:no-underline hover:prose-a:underline
              prose-blockquote:border-l-amber-400
              prose-table:text-sm"
            dangerouslySetInnerHTML={{ __html: rulesHtml }}
          />
        )}

        {activeTab === 'personajes' && (
          characters.length === 0 ? (
            <div className="text-center py-16 text-zinc-500">
              <p className="text-4xl mb-3">🧙</p>
              <p>No hay personajes registrados para este juego.</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 items-start">
              {characters.map((char, i) => (
                <CharacterCard
                  key={char.id}
                  name={char.name}
                  role={char.role}
                  description={char.description}
                  image={char.image}
                  stats={char.stats}
                  abilities={char.abilities}
                  accent={theme.accent}
                  index={i}
                />
              ))}
            </div>
          )
        )}

        {activeTab === 'historial' && (
          <ChangeHistory changelog={changelog} accent={theme.accent} />
        )}
      </div>
    </>
  );
}
