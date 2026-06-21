import { motion } from 'motion/react';

interface GameCardProps {
  slug: string;
  title: string;
  tagline: string;
  coverImage?: string;
  players: string;
  duration: string;
  difficulty: string;
  theme: {
    primary: string;
    secondary: string;
    accent: string;
    bg: string;
  };
  index: number;
}

export default function GameCard({ slug, title, tagline, coverImage, players, duration, difficulty, theme, index }: GameCardProps) {
  return (
    <motion.a
      href={`${import.meta.env.BASE_URL.replace(/\/$/, '')}/games/${slug}`}
      initial={{ opacity: 0, y: 32 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay: index * 0.1, ease: [0.25, 0.46, 0.45, 0.94] }}
      whileHover={{ y: -6, scale: 1.01 }}
      className="group relative flex flex-col overflow-hidden rounded-2xl border border-zinc-800 bg-zinc-900 cursor-pointer"
      style={{ '--glow-color': theme.accent + '55' } as React.CSSProperties}
    >
      {/* Cover image */}
      <div className="relative h-40 overflow-hidden" style={{ backgroundColor: theme.bg }}>
        {coverImage ? (
          <>
            <motion.img
              src={coverImage}
              alt={title}
              decoding="async"
              loading="lazy"
              className="w-full h-full object-contain"
              whileHover={{ scale: 1.05 }}
              transition={{ duration: 0.5 }}
            />
            <div
              className="absolute inset-0"
              style={{ background: `linear-gradient(to top, ${theme.bg} 0%, transparent 50%)` }}
            />
          </>
        ) : (
          <div className="w-full h-full flex items-center justify-center">
            <span
              className="font-display text-8xl font-black tracking-tight opacity-10 select-none"
              style={{ color: theme.primary }}
            >
              {title.charAt(0)}
            </span>
          </div>
        )}
      </div>

      {/* Content */}
      <div className="flex flex-col flex-1 p-5" style={{ backgroundColor: theme.bg + 'cc' }}>
        <h2
          className="font-display text-2xl font-bold mb-1 tracking-tight"
          style={{ color: theme.primary }}
        >
          {title}
        </h2>
        <p className="text-sm mb-4 line-clamp-2" style={{ color: theme.secondary }}>
          {tagline}
        </p>

        <div className="mt-auto flex flex-wrap gap-2 text-xs">
          <span className="badge bg-zinc-800/80 text-zinc-300">👥 {players}</span>
          <span className="badge bg-zinc-800/80 text-zinc-300">⏱ {duration}</span>
          <span
            className="badge"
            style={{ backgroundColor: theme.accent + '30', color: theme.accent }}
          >
            {difficulty}
          </span>
        </div>
      </div>

      {/* Hover border glow */}
      <motion.div
        className="absolute inset-0 rounded-2xl pointer-events-none opacity-0 group-hover:opacity-100 transition-opacity duration-300"
        style={{ boxShadow: `inset 0 0 0 1.5px ${theme.accent}66` }}
      />
    </motion.a>
  );
}
