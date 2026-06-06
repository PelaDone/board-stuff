import { supabase } from './supabase';
import type { GameSummary, GameDetail, Character, ChangelogEntry } from './types';

function toGameSummary(row: any): GameSummary {
  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    tagline: row.tagline,
    description: row.description,
    coverImage: row.cover_image,
    players: row.players,
    duration: row.duration,
    difficulty: row.difficulty,
    theme: {
      primary: row.theme_primary,
      secondary: row.theme_secondary,
      accent: row.theme_accent,
      bg: row.theme_bg,
    },
    author: row.author,
    publishedAt: row.published_at,
  };
}

export async function getAllGames(): Promise<GameSummary[]> {
  const { data, error } = await supabase
    .from('games')
    .select('*')
    .order('title');

  if (error) throw new Error(`getAllGames: ${error.message}`);
  return (data ?? []).map(toGameSummary);
}

export async function getGameBySlug(slug: string): Promise<GameDetail | null> {
  const { data: gameRow, error: gameError } = await supabase
    .from<any>('games')
    .select('*')
    .eq('slug', slug)
    .single();

  if (gameError || !gameRow) return null;

  const [rulesRes, charactersRes, changelogRes] = await Promise.all([
    supabase
      .from('game_rules')
      .select('content')
      .eq('game_id', gameRow.id)
      .single(),
    supabase
      .from('characters')
      .select(`*, character_stats(*), character_abilities(*)`)
      .eq('game_id', gameRow.id)
      .order('sort_order'),
    supabase
      .from('changelog_entries')
      .select(`*, changelog_changes(*)`)
      .eq('game_id', gameRow.id)
      .order('date', { ascending: false }),
  ]);

  const characters: Character[] = (charactersRes.data ?? []).map((c: any) => ({
    id: c.id,
    name: c.name,
    role: c.role,
    description: c.description,
    image: c.image ?? undefined,
    stats: Object.fromEntries(
      (c.character_stats ?? []).map((s: any) => [s.key, s.value])
    ),
    abilities: (c.character_abilities ?? [])
      .sort((a: any, b: any) => a.sort_order - b.sort_order)
      .map((a: any) => ({
        name: a.name,
        description: a.description,
        passive: a.passive,
      })),
  }));

  const changelog: ChangelogEntry[] = (changelogRes.data ?? []).map((e: any) => ({
    id: e.id,
    version: e.version,
    date: e.date,
    author: e.author,
    summary: e.summary,
    changes: (e.changelog_changes ?? [])
      .sort((a: any, b: any) => a.sort_order - b.sort_order)
      .map((c: any) => ({ type: c.type, description: c.description })),
  }));

  return {
    ...toGameSummary(gameRow),
    rules: rulesRes.data?.content ?? '',
    characters,
    changelog,
  };
}
