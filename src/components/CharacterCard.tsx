import { motion, AnimatePresence } from 'motion/react';
import { useState } from 'react';
import { Icon } from '@iconify/react';

interface Ability {
  name: string;
  description: string;
  passive: boolean;
}

interface CharacterCardProps {
  name: string;
  role: string;
  description: string;
  image?: string;
  stats?: Record<string, string | number>;
  abilities?: Ability[];
  accent: string;
  index: number;
}

export default function CharacterCard({ name, role, description, image, stats, abilities, accent, index }: CharacterCardProps) {
  const [expanded, setExpanded] = useState(false);

  return (
    <motion.div
      initial={{ opacity: 0, x: -20 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ duration: 0.4, delay: index * 0.08 }}
      className="rounded-xl border border-zinc-800 bg-zinc-900 overflow-hidden"
    >
      <button
        onClick={() => setExpanded(v => !v)}
        className="w-full text-left p-5 flex items-center gap-4"
      >
        {image && (
          <img
            src={image}
            alt={name}
            width={56}
            height={56}
            decoding="async"
            loading="lazy"
            className="w-14 h-14 rounded-full object-cover border-2 flex-shrink-0"
            style={{ borderColor: accent }}
          />
        )}
        <div className="flex-1 min-w-0">
          <h3 className="font-display text-lg font-bold text-zinc-100 truncate">{name}</h3>
          <p className="text-xs font-medium mt-0.5" style={{ color: accent }}>{role}</p>
        </div>
        <motion.span
          animate={{ rotate: expanded ? 180 : 0 }}
          transition={{ duration: 0.25 }}
          className="text-zinc-500 flex-shrink-0"
        >
          <Icon icon="lucide:chevron-down" className="w-5 h-5" />
        </motion.span>
      </button>

      <AnimatePresence>
        {expanded && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.3, ease: 'easeInOut' }}
            className="overflow-hidden"
          >
            <div className="px-5 pb-5 space-y-4 border-t border-zinc-800 pt-4">
              <p className="text-sm text-zinc-400 leading-relaxed">{description}</p>

              {stats && Object.keys(stats).length > 0 && (
                <div>
                  <h4 className="text-xs uppercase tracking-widest text-zinc-500 mb-2">Estadísticas</h4>
                  <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
                    {Object.entries(stats).map(([key, value]) => (
                      <div key={key} className="rounded-lg bg-zinc-800/50 p-2 text-center">
                        <div className="text-lg font-bold" style={{ color: accent }}>{value}</div>
                        <div className="text-xs text-zinc-500 capitalize">{key}</div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {abilities && abilities.length > 0 && (
                <div>
                  <h4 className="text-xs uppercase tracking-widest text-zinc-500 mb-2">Habilidades</h4>
                  <ul className="space-y-2">
                    {abilities.map(ability => (
                      <li key={ability.name} className="flex gap-3 text-sm">
                        <span
                          className="flex-shrink-0 mt-0.5 text-xs font-bold px-1.5 py-0.5 rounded"
                          style={{ backgroundColor: accent + '25', color: accent }}
                        >
                          {ability.passive ? 'PAS' : 'ACT'}
                        </span>
                        <div>
                          <span className="font-medium text-zinc-200">{ability.name}: </span>
                          <span className="text-zinc-400">{ability.description}</span>
                        </div>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}
