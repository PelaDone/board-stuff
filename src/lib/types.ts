export type Difficulty = 'Fácil' | 'Intermedio' | 'Difícil' | 'Experto';
export type ChangeType = 'rule' | 'stat' | 'character' | 'mechanic' | 'balance' | 'clarification';

export interface Database {
  public: {
    Tables: {
      games: {
        Row: {
          id: string;
          slug: string;
          title: string;
          tagline: string;
          description: string;
          cover_image: string | null;
          players: string;
          duration: string;
          difficulty: Difficulty;
          theme_primary: string;
          theme_secondary: string;
          theme_accent: string;
          theme_bg: string;
          published_at: string;
          author: string;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['games']['Row'], 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['games']['Insert']>;
      };
      game_rules: {
        Row: {
          id: string;
          game_id: string;
          content: string;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['game_rules']['Row'], 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['game_rules']['Insert']>;
      };
      characters: {
        Row: {
          id: string;
          game_id: string;
          name: string;
          role: string;
          description: string;
          image: string | null;
          sort_order: number;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['characters']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['characters']['Insert']>;
      };
      character_stats: {
        Row: {
          id: string;
          character_id: string;
          key: string;
          value: string;
        };
        Insert: Omit<Database['public']['Tables']['character_stats']['Row'], 'id'>;
        Update: Partial<Database['public']['Tables']['character_stats']['Insert']>;
      };
      character_abilities: {
        Row: {
          id: string;
          character_id: string;
          name: string;
          description: string;
          passive: boolean;
          sort_order: number;
        };
        Insert: Omit<Database['public']['Tables']['character_abilities']['Row'], 'id'>;
        Update: Partial<Database['public']['Tables']['character_abilities']['Insert']>;
      };
      changelog_entries: {
        Row: {
          id: string;
          game_id: string;
          version: string;
          date: string;
          author: string;
          summary: string;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['changelog_entries']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['changelog_entries']['Insert']>;
      };
      changelog_changes: {
        Row: {
          id: string;
          changelog_entry_id: string;
          type: ChangeType;
          description: string;
          sort_order: number;
        };
        Insert: Omit<Database['public']['Tables']['changelog_changes']['Row'], 'id'>;
        Update: Partial<Database['public']['Tables']['changelog_changes']['Insert']>;
      };
    };
  };
}

// Enriched types used in the app
export interface GameSummary {
  id: string;
  slug: string;
  title: string;
  tagline: string;
  description: string;
  coverImage: string | null;
  players: string;
  duration: string;
  difficulty: Difficulty;
  theme: { primary: string; secondary: string; accent: string; bg: string };
  author: string;
  publishedAt: string;
}

export interface Character {
  id: string;
  name: string;
  role: string;
  description: string;
  image?: string;
  stats: Record<string, string>;
  abilities: { name: string; description: string; passive: boolean }[];
}

export interface ChangelogEntry {
  id: string;
  version: string;
  date: string;
  author: string;
  summary: string;
  changes: { type: ChangeType; description: string }[];
}

export interface GameDetail extends GameSummary {
  rules: string;
  characters: Character[];
  changelog: ChangelogEntry[];
}
