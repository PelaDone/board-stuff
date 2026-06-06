import { motion } from 'motion/react';

interface ChangeEntry {
  type: 'rule' | 'stat' | 'character' | 'mechanic' | 'balance' | 'clarification';
  description: string;
}

interface ChangelogEntry {
  date: string;
  version: string;
  author: string;
  summary: string;
  changes: ChangeEntry[];
}

interface ChangeHistoryProps {
  changelog: ChangelogEntry[];
  accent: string;
}

const typeConfig: Record<ChangeEntry['type'], { label: string; color: string }> = {
  rule:          { label: 'Regla',         color: '#60a5fa' },
  stat:          { label: 'Estadística',   color: '#a78bfa' },
  character:     { label: 'Personaje',     color: '#34d399' },
  mechanic:      { label: 'Mecánica',      color: '#f59e0b' },
  balance:       { label: 'Balance',       color: '#f87171' },
  clarification: { label: 'Aclaración',    color: '#94a3b8' },
};

export default function ChangeHistory({ changelog, accent }: ChangeHistoryProps) {
  if (changelog.length === 0) {
    return (
      <div className="text-center py-16 text-zinc-500">
        <p className="text-4xl mb-3">📋</p>
        <p>No hay cambios registrados todavía.</p>
      </div>
    );
  }

  const sorted = [...changelog].sort((a, b) => b.date.localeCompare(a.date));

  return (
    <div className="relative">
      {/* Timeline line */}
      <div className="absolute left-4 top-0 bottom-0 w-px bg-zinc-800" />

      <div className="space-y-8 pl-10">
        {sorted.map((entry, i) => (
          <motion.div
            key={`${entry.version}-${i}`}
            initial={{ opacity: 0, x: -16 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.4, delay: i * 0.07 }}
            className="relative"
          >
            {/* Dot */}
            <div
              className="absolute -left-10 mt-1 w-3 h-3 rounded-full border-2 border-zinc-950"
              style={{ backgroundColor: i === 0 ? accent : '#3f3f46' }}
            />

            <div className="rounded-xl border border-zinc-800 bg-zinc-900 p-5">
              <div className="flex flex-wrap items-start justify-between gap-2 mb-3">
                <div>
                  <span
                    className="font-display font-bold text-base"
                    style={{ color: i === 0 ? accent : '#e4e4e7' }}
                  >
                    v{entry.version}
                  </span>
                  <span className="text-zinc-500 text-sm ml-3">{entry.date}</span>
                </div>
                <span className="text-xs text-zinc-500">por {entry.author}</span>
              </div>

              <p className="text-sm text-zinc-300 mb-4 font-medium">{entry.summary}</p>

              <ul className="space-y-2">
                {entry.changes.map((change, j) => {
                  const cfg = typeConfig[change.type];
                  return (
                    <li key={j} className="flex gap-2.5 text-sm">
                      <span
                        className="flex-shrink-0 text-[10px] font-bold px-1.5 py-0.5 rounded self-start mt-0.5"
                        style={{ backgroundColor: cfg.color + '20', color: cfg.color }}
                      >
                        {cfg.label.toUpperCase()}
                      </span>
                      <span className="text-zinc-400">{change.description}</span>
                    </li>
                  );
                })}
              </ul>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
