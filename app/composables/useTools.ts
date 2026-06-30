export interface ToolField {
  id: string
  label: string
  type: 'text' | 'textarea' | 'list' | 'photo' | 'photo-gallery'
  placeholder?: string
  hint?: string
  suggestions?: string[]
  allowCamera?: boolean
}

export interface ToolStep {
  id: string
  title: string
  description?: string
  fields: ToolField[]
}

export interface ToolDefinition {
  id: string
  name: string
  category: 'micro' | 'macro'
  tagline: string
  description: string
  icon: string
  colour: 'teal' | 'coral' | 'navy'
  steps: ToolStep[]
}

const microTools: ToolDefinition[] = [
  {
    id: 'about-me',
    name: 'About Me',
    category: 'micro',
    tagline: 'A short, clear summary of you',
    description: 'What people like about you, what matters to you, and how to support you well.',
    icon: 'user',
    colour: 'teal',
    steps: [
      {
        id: 'basics',
        title: 'The basics',
        description: 'Start with your name and, if you like, a photo.',
        fields: [
          { id: 'name', label: 'My name', type: 'text', placeholder: 'Enter your name' },
          { id: 'photo', label: 'My photo', type: 'photo', hint: 'Optional. Add a photo to make it personal.', allowCamera: true },
        ],
      },
      {
        id: 'admire',
        title: 'What people like and admire about me',
        description: 'Think about what friends, family, or supporters would say they like about you.',
        fields: [
          {
            id: 'admire', label: 'What people like and admire about me', type: 'list',
            placeholder: 'e.g. Always remembers birthdays',
            suggestions: [
              'Kind', 'Caring', 'Funny', 'Brave', 'Thoughtful',
              'Patient', 'Loyal', 'Honest', 'Creative', 'Cheerful',
              'Friendly', 'Generous', 'Gentle', 'Confident', 'Helpful',
              'Organised', 'Calm', 'Resilient', 'Determined', 'Supportive',
              'Enthusiastic', 'Reliable', 'Positive', 'Warm', 'Hard-working',
            ],
          },
        ],
      },
      {
        id: 'important',
        title: 'What is important to me',
        description: 'What really matters in your life. People, routines, hobbies, places.',
        fields: [
          { id: 'important', label: 'What is important to me', type: 'list', placeholder: 'e.g. Seeing my family every week' },
          { id: 'important-photos', label: 'Photos', type: 'photo-gallery', hint: 'Add photos of what matters to you.' },
        ],
      },
      {
        id: 'support',
        title: 'How to support me well',
        description: 'What do people need to know to support you in the best way?',
        fields: [
          { id: 'support', label: 'How to support me well', type: 'list', placeholder: 'e.g. Give me time to answer questions' },
          { id: 'support-photos', label: 'Photos', type: 'photo-gallery', hint: 'Add photos to help explain how to support you.' },
        ],
      },
    ],
  },
  {
    id: 'what-matters',
    name: 'What Matters & What Helps',
    category: 'micro',
    tagline: 'Balance what you want with what keeps you well',
    description: 'Explore what matters to you and what is important for your wellbeing, health, and safety.',
    icon: 'balance',
    colour: 'teal',
    steps: [
      {
        id: 'person',
        title: 'Who is this about?',
        fields: [
          { id: 'name', label: 'Name', type: 'text', placeholder: 'Enter the person\'s name' },
          { id: 'person-photo', label: 'Photo', type: 'photo-gallery', hint: 'Add a photo of the person.' },
        ],
      },
      {
        id: 'matters',
        title: 'What matters to me',
        description: 'The things that make life good. What you enjoy, value, and care about.',
        fields: [
          { id: 'matters', label: 'What matters to me', type: 'list', placeholder: 'e.g. Having a cup of tea first thing in the morning' },
          { id: 'matters-photos', label: 'Photos', type: 'photo-gallery', hint: 'Add photos of what matters.' },
        ],
      },
      {
        id: 'helps',
        title: 'What helps me stay well',
        description: 'What keeps you safe, healthy, and well. Things others think are important for you.',
        fields: [
          { id: 'helps', label: 'What helps me stay well', type: 'list', placeholder: 'e.g. Taking my medication at the same time every day' },
          { id: 'helps-photos', label: 'Photos', type: 'photo-gallery', hint: 'Add photos of what helps.' },
        ],
      },
    ],
  },
  {
    id: 'my-people',
    name: 'My People',
    category: 'micro',
    tagline: 'Map the people in your life',
    description: 'Understand who matters to you and how close those relationships are.',
    icon: 'people',
    colour: 'teal',
    steps: [
      {
        id: 'person',
        title: 'Who is this about?',
        fields: [
          { id: 'name', label: 'Name', type: 'text', placeholder: 'Enter your name' },
        ],
      },
      {
        id: 'closest',
        title: 'Closest to me',
        description: 'The people you are closest to. Family, best friends, partners.',
        fields: [
          { id: 'closest', label: 'My closest people', type: 'list', placeholder: 'e.g. Mum, partner, best friend Sarah' },
        ],
      },
      {
        id: 'important',
        title: 'Important to me',
        description: 'People who matter, but not quite as close. Good friends, extended family.',
        fields: [
          { id: 'important', label: 'Important people', type: 'list', placeholder: 'e.g. Cousin James, neighbour Pat' },
        ],
      },
      {
        id: 'wider',
        title: 'Wider circle',
        description: 'People you know and interact with. Colleagues, acquaintances, support workers.',
        fields: [
          { id: 'wider', label: 'Wider connections', type: 'list', placeholder: 'e.g. GP, support worker Mark, colleagues' },
        ],
      },
      {
        id: 'paid',
        title: 'Paid support',
        description: 'Professionals and paid staff who support you.',
        fields: [
          { id: 'paid', label: 'Paid support', type: 'list', placeholder: 'e.g. Care coordinator, key worker' },
        ],
      },
    ],
  },
  {
    id: 'best-worst-day',
    name: 'My Best Day / My Worst Day',
    category: 'micro',
    tagline: 'Understand what makes a good or bad day',
    description: 'Spot patterns and plan for more good days and fewer bad ones.',
    icon: 'sun-cloud',
    colour: 'teal',
    steps: [
      {
        id: 'person',
        title: 'Who is this about?',
        fields: [
          { id: 'name', label: 'Name', type: 'text', placeholder: 'Enter the person\'s name' },
          { id: 'person-photo', label: 'Photo', type: 'photo-gallery', hint: 'Add a photo.' },
        ],
      },
      {
        id: 'best',
        title: 'My best day',
        description: 'What does a really good day look like? Think about people, places, activities, routines.',
        fields: [
          { id: 'best', label: 'What makes a good day', type: 'list', placeholder: 'e.g. Waking up without rushing, seeing a friend for coffee' },
          { id: 'best-photos', label: 'Photos', type: 'photo-gallery', hint: 'Add photos of good day moments.' },
        ],
      },
      {
        id: 'worst',
        title: 'My worst day',
        description: 'What makes a bad day? What goes wrong, what feels difficult?',
        fields: [
          { id: 'worst', label: 'What makes a bad day', type: 'list', placeholder: 'e.g. Plans changing at the last minute, being rushed' },
          { id: 'worst-photos', label: 'Photos', type: 'photo-gallery', hint: 'Add photos if it helps to explain.' },
        ],
      },
      {
        id: 'action',
        title: 'What will it take?',
        description: 'What needs to happen to have more good days and fewer bad ones?',
        fields: [
          { id: 'action', label: 'What will it take to have more good days', type: 'list', placeholder: 'e.g. A consistent morning routine, regular contact with friends' },
          { id: 'action-photos', label: 'Photos', type: 'photo-gallery', hint: 'Add photos of what will help.' },
        ],
      },
    ],
  },
  {
    id: 'whats-working',
    name: "What's Working",
    category: 'micro',
    tagline: 'Reflect on what is going well and what is not',
    description: 'Look at things from different perspectives to agree what needs to happen next.',
    icon: 'check-cross',
    colour: 'teal',
    steps: [
      {
        id: 'person',
        title: 'Who is this about?',
        fields: [
          { id: 'name', label: 'Name', type: 'text', placeholder: 'Enter the person\'s name' },
        ],
      },
      {
        id: 'person-view',
        title: 'From the person\'s perspective',
        description: 'What does the person themselves think is working and not working?',
        fields: [
          { id: 'person-working', label: "What's working", type: 'list', placeholder: 'e.g. I enjoy my Tuesday group' },
          { id: 'person-not-working', label: "What's not working", type: 'list', placeholder: 'e.g. I feel lonely at weekends' },
        ],
      },
      {
        id: 'family-view',
        title: 'From family\'s perspective',
        description: 'What do family members or close people think?',
        fields: [
          { id: 'family-working', label: "What's working", type: 'list', placeholder: 'e.g. They seem happier since starting the new activity' },
          { id: 'family-not-working', label: "What's not working", type: 'list', placeholder: 'e.g. Communication with the support team has been poor' },
        ],
      },
      {
        id: 'staff-view',
        title: 'From staff\'s perspective',
        description: 'What do support workers, professionals, or staff think?',
        fields: [
          { id: 'staff-working', label: "What's working", type: 'list', placeholder: 'e.g. The person is engaging well with activities' },
          { id: 'staff-not-working', label: "What's not working", type: 'list', placeholder: 'e.g. The morning routine takes too long' },
        ],
      },
      {
        id: 'next-steps',
        title: 'What needs to happen next?',
        description: 'Based on all perspectives, what should change?',
        fields: [
          { id: 'next-steps', label: 'Actions to build on what works and change what doesn\'t', type: 'list', placeholder: 'e.g. Set up a weekly call with family' },
        ],
      },
    ],
  },
  {
    id: 'how-i-communicate',
    name: 'How I Communicate',
    category: 'micro',
    tagline: 'Help others understand how you communicate',
    description: 'Record what you do, what it might mean, and how others should respond.',
    icon: 'chat',
    colour: 'teal',
    steps: [
      {
        id: 'person',
        title: 'Who is this about?',
        fields: [
          { id: 'name', label: 'Name', type: 'text', placeholder: 'Enter the person\'s name' },
        ],
      },
      {
        id: 'happy',
        title: 'When I am happy or comfortable',
        description: 'What do you do when you are feeling good? How should people respond?',
        fields: [
          { id: 'happy-signs', label: 'What happens', type: 'list', placeholder: 'e.g. I smile and make eye contact' },
          { id: 'happy-meaning', label: 'What it means', type: 'textarea', placeholder: 'e.g. I am feeling relaxed and enjoying the situation' },
          { id: 'happy-response', label: 'How to respond', type: 'textarea', placeholder: 'e.g. Keep doing what you are doing, chat with me' },
        ],
      },
      {
        id: 'unhappy',
        title: 'When I am unhappy or uncomfortable',
        description: 'What do you do when something is wrong? How should people respond?',
        fields: [
          { id: 'unhappy-signs', label: 'What happens', type: 'list', placeholder: 'e.g. I go quiet and look away' },
          { id: 'unhappy-meaning', label: 'What it means', type: 'textarea', placeholder: 'e.g. I am feeling anxious or overwhelmed' },
          { id: 'unhappy-response', label: 'How to respond', type: 'textarea', placeholder: 'e.g. Give me space, speak softly, ask if I want to leave' },
        ],
      },
      {
        id: 'needs',
        title: 'When I need or want something',
        description: 'How do you let people know you need something?',
        fields: [
          { id: 'needs-signs', label: 'What happens', type: 'list', placeholder: 'e.g. I point or reach towards things' },
          { id: 'needs-meaning', label: 'What it means', type: 'textarea', placeholder: 'e.g. I want that item or want to go there' },
          { id: 'needs-response', label: 'How to respond', type: 'textarea', placeholder: 'e.g. Offer choices, follow my lead' },
        ],
      },
    ],
  },
  {
    id: 'my-perfect-week',
    name: 'My Perfect Week',
    category: 'micro',
    tagline: 'Plan what a great week looks like',
    description: 'Map out mornings, afternoons, and evenings across the week.',
    icon: 'calendar',
    colour: 'teal',
    steps: [
      {
        id: 'person',
        title: 'Who is this about?',
        fields: [
          { id: 'name', label: 'Name', type: 'text', placeholder: 'Enter your name' },
        ],
      },
      {
        id: 'mornings',
        title: 'Mornings',
        description: 'What would a perfect morning look like on each day?',
        fields: [
          { id: 'mon-morning', label: 'Monday', type: 'textarea', placeholder: 'e.g. Slow breakfast, a walk before work' },
          { id: 'tue-morning', label: 'Tuesday', type: 'textarea', placeholder: '' },
          { id: 'wed-morning', label: 'Wednesday', type: 'textarea', placeholder: '' },
          { id: 'thu-morning', label: 'Thursday', type: 'textarea', placeholder: '' },
          { id: 'fri-morning', label: 'Friday', type: 'textarea', placeholder: '' },
          { id: 'sat-morning', label: 'Saturday', type: 'textarea', placeholder: '' },
          { id: 'sun-morning', label: 'Sunday', type: 'textarea', placeholder: '' },
        ],
      },
      {
        id: 'afternoons',
        title: 'Afternoons',
        description: 'What would a perfect afternoon look like on each day?',
        fields: [
          { id: 'mon-afternoon', label: 'Monday', type: 'textarea', placeholder: '' },
          { id: 'tue-afternoon', label: 'Tuesday', type: 'textarea', placeholder: '' },
          { id: 'wed-afternoon', label: 'Wednesday', type: 'textarea', placeholder: '' },
          { id: 'thu-afternoon', label: 'Thursday', type: 'textarea', placeholder: '' },
          { id: 'fri-afternoon', label: 'Friday', type: 'textarea', placeholder: '' },
          { id: 'sat-afternoon', label: 'Saturday', type: 'textarea', placeholder: '' },
          { id: 'sun-afternoon', label: 'Sunday', type: 'textarea', placeholder: '' },
        ],
      },
      {
        id: 'evenings',
        title: 'Evenings',
        description: 'What would a perfect evening look like on each day?',
        fields: [
          { id: 'mon-evening', label: 'Monday', type: 'textarea', placeholder: '' },
          { id: 'tue-evening', label: 'Tuesday', type: 'textarea', placeholder: '' },
          { id: 'wed-evening', label: 'Wednesday', type: 'textarea', placeholder: '' },
          { id: 'thu-evening', label: 'Thursday', type: 'textarea', placeholder: '' },
          { id: 'fri-evening', label: 'Friday', type: 'textarea', placeholder: '' },
          { id: 'sat-evening', label: 'Saturday', type: 'textarea', placeholder: '' },
          { id: 'sun-evening', label: 'Sunday', type: 'textarea', placeholder: '' },
        ],
      },
    ],
  },
]

export function useTools() {
  const tools = microTools

  function getToolById(id: string): ToolDefinition | undefined {
    return tools.find(t => t.id === id)
  }

  return { tools, getToolById }
}
