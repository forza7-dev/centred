import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/field_type.dart';
import '../models/tool_definition.dart';
import '../models/tool_field.dart';
import '../models/tool_step.dart';

/// Static tool catalog, ported verbatim from
/// `design-reference/app/composables/useTools.ts`.
final toolCatalogProvider =
    Provider<List<ToolDefinition>>((ref) => _catalog);

final toolByIdProvider = Provider.family<ToolDefinition?, String>((ref, id) {
  final tools = ref.watch(toolCatalogProvider);
  for (final tool in tools) {
    if (tool.id == id) return tool;
  }
  return null;
});

const List<ToolDefinition> _catalog = [..._microTools, ..._macroTools];

const List<ToolDefinition> _microTools = [
  ToolDefinition(
    id: 'about-me',
    name: 'About Me',
    category: ToolCategory.micro,
    tagline: 'A short, clear summary of you',
    description:
        'What people like about you, what matters to you, and how to support you well.',
    icon: Icons.person_outline,
    colour: ToolAccentColour.teal,
    steps: [
      ToolStep(
        id: 'basics',
        title: 'The basics',
        description: 'Start with your name and, if you like, a photo.',
        fields: [
          ToolField(id: 'name', label: 'My name', type: FieldType.text, placeholder: 'Enter your name'),
          ToolField(
            id: 'photo',
            label: 'My photo',
            type: FieldType.photo,
            hint: 'Optional. Add a photo to make it personal.',
            allowCamera: true,
          ),
        ],
      ),
      ToolStep(
        id: 'admire',
        title: 'What people like and admire about me',
        description:
            'Think about what friends, family, or supporters would say they like about you.',
        fields: [
          ToolField(
            id: 'admire',
            label: 'What people like and admire about me',
            type: FieldType.list,
            placeholder: 'e.g. Always remembers birthdays',
            suggestions: [
              'Kind', 'Caring', 'Funny', 'Brave', 'Thoughtful',
              'Patient', 'Loyal', 'Honest', 'Creative', 'Cheerful',
              'Friendly', 'Generous', 'Gentle', 'Confident', 'Helpful',
              'Organised', 'Calm', 'Resilient', 'Determined', 'Supportive',
              'Enthusiastic', 'Reliable', 'Positive', 'Warm', 'Hard-working',
            ],
          ),
        ],
      ),
      ToolStep(
        id: 'important',
        title: 'What is important to me',
        description:
            'What really matters in your life. People, routines, hobbies, places.',
        fields: [
          ToolField(id: 'important', label: 'What is important to me', type: FieldType.list, placeholder: 'e.g. Seeing my family every week'),
          ToolField(id: 'important-photos', label: 'Photos', type: FieldType.photoGallery, hint: 'Add photos of what matters to you.'),
        ],
      ),
      ToolStep(
        id: 'support',
        title: 'How to support me well',
        description: 'What do people need to know to support you in the best way?',
        fields: [
          ToolField(id: 'support', label: 'How to support me well', type: FieldType.list, placeholder: 'e.g. Give me time to answer questions'),
          ToolField(id: 'support-photos', label: 'Photos', type: FieldType.photoGallery, hint: 'Add photos to help explain how to support you.'),
        ],
      ),
    ],
  ),
  ToolDefinition(
    id: 'what-matters',
    name: 'What Matters & What Helps',
    category: ToolCategory.micro,
    tagline: 'Balance what you want with what keeps you well',
    description:
        'Explore what matters to you and what is important for your wellbeing, health, and safety.',
    icon: Icons.balance,
    colour: ToolAccentColour.teal,
    steps: [
      ToolStep(
        id: 'person',
        title: 'Who is this about?',
        fields: [
          ToolField(id: 'name', label: 'Name', type: FieldType.text, placeholder: "Enter the person's name"),
          ToolField(id: 'person-photo', label: 'Photo', type: FieldType.photoGallery, hint: 'Add a photo of the person.'),
        ],
      ),
      ToolStep(
        id: 'matters',
        title: 'What matters to me',
        description: 'The things that make life good. What you enjoy, value, and care about.',
        fields: [
          ToolField(id: 'matters', label: 'What matters to me', type: FieldType.list, placeholder: 'e.g. Having a cup of tea first thing in the morning'),
          ToolField(id: 'matters-photos', label: 'Photos', type: FieldType.photoGallery, hint: 'Add photos of what matters.'),
        ],
      ),
      ToolStep(
        id: 'helps',
        title: 'What helps me stay well',
        description: 'What keeps you safe, healthy, and well. Things others think are important for you.',
        fields: [
          ToolField(id: 'helps', label: 'What helps me stay well', type: FieldType.list, placeholder: 'e.g. Taking my medication at the same time every day'),
          ToolField(id: 'helps-photos', label: 'Photos', type: FieldType.photoGallery, hint: 'Add photos of what helps.'),
        ],
      ),
    ],
  ),
  ToolDefinition(
    id: 'my-people',
    name: 'My People',
    category: ToolCategory.micro,
    tagline: 'Map the people in your life',
    description: 'Understand who matters to you and how close those relationships are.',
    icon: Icons.people_outline,
    colour: ToolAccentColour.teal,
    steps: [
      ToolStep(
        id: 'person',
        title: 'Who is this about?',
        fields: [
          ToolField(id: 'name', label: 'Name', type: FieldType.text, placeholder: 'Enter your name'),
          ToolField(
            id: 'me-photo',
            label: 'My photo',
            type: FieldType.photo,
            hint: 'Optional. Shown in the centre of the diagram.',
            allowCamera: true,
          ),
        ],
      ),
      ToolStep(
        id: 'closest',
        title: 'Closest to me',
        description: 'The people you are closest to. Family, best friends, partners.',
        fields: [
          ToolField(id: 'closest', label: 'My closest people', type: FieldType.listWithPhoto, placeholder: 'e.g. Mum, partner, best friend Sarah'),
        ],
      ),
      ToolStep(
        id: 'important',
        title: 'Important to me',
        description: 'People who matter, but not quite as close. Good friends, extended family.',
        fields: [
          ToolField(id: 'important', label: 'Important people', type: FieldType.listWithPhoto, placeholder: 'e.g. Cousin James, neighbour Pat'),
        ],
      ),
      ToolStep(
        id: 'wider',
        title: 'Other people in my life',
        description: 'People you know and interact with. Colleagues, acquaintances, support workers.',
        fields: [
          ToolField(id: 'wider', label: 'Other people in my life', type: FieldType.listWithPhoto, placeholder: 'e.g. GP, support worker Mark, colleagues'),
        ],
      ),
      ToolStep(
        id: 'paid',
        title: 'Paid support',
        description: 'Professionals and paid staff who support you.',
        fields: [
          ToolField(id: 'paid', label: 'Paid support', type: FieldType.listWithPhoto, placeholder: 'e.g. Care coordinator, key worker'),
        ],
      ),
    ],
  ),
  ToolDefinition(
    id: 'best-worst-day',
    name: 'My Best Day / My Worst Day',
    category: ToolCategory.micro,
    tagline: 'Understand what makes a good or bad day',
    description: 'Spot patterns and plan for more good days and fewer bad ones.',
    icon: Icons.wb_cloudy_outlined,
    colour: ToolAccentColour.teal,
    steps: [
      ToolStep(
        id: 'person',
        title: 'Who is this about?',
        fields: [
          ToolField(id: 'name', label: 'Name', type: FieldType.text, placeholder: "Enter the person's name"),
          ToolField(id: 'person-photo', label: 'Photo', type: FieldType.photoGallery, hint: 'Add a photo.'),
        ],
      ),
      ToolStep(
        id: 'best',
        title: 'My best day',
        description: 'What does a really good day look like? Think about people, places, activities, routines.',
        fields: [
          ToolField(id: 'best', label: 'What makes a good day', type: FieldType.list, placeholder: 'e.g. Waking up without rushing, seeing a friend for coffee'),
          ToolField(id: 'best-photos', label: 'Photos', type: FieldType.photoGallery, hint: 'Add photos of good day moments.'),
        ],
      ),
      ToolStep(
        id: 'worst',
        title: 'My worst day',
        description: 'What makes a bad day? What goes wrong, what feels difficult?',
        fields: [
          ToolField(id: 'worst', label: 'What makes a bad day', type: FieldType.list, placeholder: 'e.g. Plans changing at the last minute, being rushed'),
          ToolField(id: 'worst-photos', label: 'Photos', type: FieldType.photoGallery, hint: 'Add photos if it helps to explain.'),
        ],
      ),
      ToolStep(
        id: 'action',
        title: 'What will it take?',
        description: 'What needs to happen to have more good days and fewer bad ones?',
        fields: [
          ToolField(id: 'action', label: 'What will it take to have more good days', type: FieldType.list, placeholder: 'e.g. A consistent morning routine, regular contact with friends'),
          ToolField(id: 'action-photos', label: 'Photos', type: FieldType.photoGallery, hint: 'Add photos of what will help.'),
        ],
      ),
    ],
  ),
  ToolDefinition(
    id: 'whats-working',
    name: "What's Working",
    category: ToolCategory.micro,
    tagline: 'Reflect on what is going well and what is not',
    description: 'Look at things from different perspectives to agree what needs to happen next.',
    icon: Icons.fact_check_outlined,
    colour: ToolAccentColour.teal,
    steps: [
      ToolStep(
        id: 'person',
        title: 'Who is this about?',
        fields: [
          ToolField(id: 'name', label: 'Name', type: FieldType.text, placeholder: "Enter the person's name"),
        ],
      ),
      ToolStep(
        id: 'person-view',
        title: "From the person's perspective",
        description: 'What does the person themselves think is working and not working?',
        fields: [
          ToolField(id: 'person-working', label: "What's working", type: FieldType.list, placeholder: 'e.g. I enjoy my Tuesday group'),
          ToolField(id: 'person-not-working', label: "What's not working", type: FieldType.list, placeholder: 'e.g. I feel lonely at weekends'),
        ],
      ),
      ToolStep(
        id: 'family-view',
        title: "From family's perspective",
        description: 'What do family members or close people think?',
        fields: [
          ToolField(id: 'family-working', label: "What's working", type: FieldType.list, placeholder: 'e.g. They seem happier since starting the new activity'),
          ToolField(id: 'family-not-working', label: "What's not working", type: FieldType.list, placeholder: 'e.g. Communication with the support team has been poor'),
        ],
      ),
      ToolStep(
        id: 'staff-view',
        title: "From staff's perspective",
        description: 'What do support workers, professionals, or staff think?',
        fields: [
          ToolField(id: 'staff-working', label: "What's working", type: FieldType.list, placeholder: 'e.g. The person is engaging well with activities'),
          ToolField(id: 'staff-not-working', label: "What's not working", type: FieldType.list, placeholder: 'e.g. The morning routine takes too long'),
        ],
      ),
      ToolStep(
        id: 'next-steps',
        title: 'What needs to happen next?',
        description: 'Based on all perspectives, what should change?',
        fields: [
          ToolField(id: 'next-steps', label: "Actions to build on what works and change what doesn't", type: FieldType.list, placeholder: 'e.g. Set up a weekly call with family'),
        ],
      ),
    ],
  ),
  ToolDefinition(
    id: 'how-i-communicate',
    name: 'How I Communicate',
    category: ToolCategory.micro,
    tagline: 'Help others understand how you communicate',
    description: 'Record what you do, what it might mean, and how others should respond.',
    icon: Icons.chat_bubble_outline,
    colour: ToolAccentColour.teal,
    steps: [
      ToolStep(
        id: 'person',
        title: 'Who is this about?',
        fields: [
          ToolField(id: 'name', label: 'Name', type: FieldType.text, placeholder: "Enter the person's name"),
        ],
      ),
      ToolStep(
        id: 'happy',
        title: 'When I am happy or comfortable',
        description: 'What do you do when you are feeling good? How should people respond?',
        fields: [
          ToolField(id: 'happy-signs', label: 'What happens', type: FieldType.list, placeholder: 'e.g. I smile and make eye contact'),
          ToolField(id: 'happy-meaning', label: 'What it means', type: FieldType.textarea, placeholder: 'e.g. I am feeling relaxed and enjoying the situation'),
          ToolField(id: 'happy-response', label: 'How to respond', type: FieldType.textarea, placeholder: 'e.g. Keep doing what you are doing, chat with me'),
        ],
      ),
      ToolStep(
        id: 'unhappy',
        title: 'When I am unhappy or uncomfortable',
        description: 'What do you do when something is wrong? How should people respond?',
        fields: [
          ToolField(id: 'unhappy-signs', label: 'What happens', type: FieldType.list, placeholder: 'e.g. I go quiet and look away'),
          ToolField(id: 'unhappy-meaning', label: 'What it means', type: FieldType.textarea, placeholder: 'e.g. I am feeling anxious or overwhelmed'),
          ToolField(id: 'unhappy-response', label: 'How to respond', type: FieldType.textarea, placeholder: 'e.g. Give me space, speak softly, ask if I want to leave'),
        ],
      ),
      ToolStep(
        id: 'needs',
        title: 'When I need or want something',
        description: 'How do you let people know you need something?',
        fields: [
          ToolField(id: 'needs-signs', label: 'What happens', type: FieldType.list, placeholder: 'e.g. I point or reach towards things'),
          ToolField(id: 'needs-meaning', label: 'What it means', type: FieldType.textarea, placeholder: 'e.g. I want that item or want to go there'),
          ToolField(id: 'needs-response', label: 'How to respond', type: FieldType.textarea, placeholder: 'e.g. Offer choices, follow my lead'),
        ],
      ),
    ],
  ),
  ToolDefinition(
    id: 'my-perfect-week',
    name: 'My Perfect Week',
    category: ToolCategory.micro,
    tagline: 'Plan what a great week looks like',
    description: 'Map out mornings, afternoons, and evenings across the week.',
    icon: Icons.calendar_today_outlined,
    colour: ToolAccentColour.teal,
    steps: [
      ToolStep(
        id: 'person',
        title: 'Who is this about?',
        fields: [
          ToolField(id: 'name', label: 'Name', type: FieldType.text, placeholder: 'Enter your name'),
        ],
      ),
      ToolStep(
        id: 'mornings',
        title: 'Mornings',
        description: 'What would a perfect morning look like on each day?',
        fields: [
          ToolField(id: 'mon-morning', label: 'Monday', type: FieldType.textarea, placeholder: 'e.g. Slow breakfast, a walk before work'),
          ToolField(id: 'tue-morning', label: 'Tuesday', type: FieldType.textarea),
          ToolField(id: 'wed-morning', label: 'Wednesday', type: FieldType.textarea),
          ToolField(id: 'thu-morning', label: 'Thursday', type: FieldType.textarea),
          ToolField(id: 'fri-morning', label: 'Friday', type: FieldType.textarea),
          ToolField(id: 'sat-morning', label: 'Saturday', type: FieldType.textarea),
          ToolField(id: 'sun-morning', label: 'Sunday', type: FieldType.textarea),
        ],
      ),
      ToolStep(
        id: 'afternoons',
        title: 'Afternoons',
        description: 'What would a perfect afternoon look like on each day?',
        fields: [
          ToolField(id: 'mon-afternoon', label: 'Monday', type: FieldType.textarea),
          ToolField(id: 'tue-afternoon', label: 'Tuesday', type: FieldType.textarea),
          ToolField(id: 'wed-afternoon', label: 'Wednesday', type: FieldType.textarea),
          ToolField(id: 'thu-afternoon', label: 'Thursday', type: FieldType.textarea),
          ToolField(id: 'fri-afternoon', label: 'Friday', type: FieldType.textarea),
          ToolField(id: 'sat-afternoon', label: 'Saturday', type: FieldType.textarea),
          ToolField(id: 'sun-afternoon', label: 'Sunday', type: FieldType.textarea),
        ],
      ),
      ToolStep(
        id: 'evenings',
        title: 'Evenings',
        description: 'What would a perfect evening look like on each day?',
        fields: [
          ToolField(id: 'mon-evening', label: 'Monday', type: FieldType.textarea),
          ToolField(id: 'tue-evening', label: 'Tuesday', type: FieldType.textarea),
          ToolField(id: 'wed-evening', label: 'Wednesday', type: FieldType.textarea),
          ToolField(id: 'thu-evening', label: 'Thursday', type: FieldType.textarea),
          ToolField(id: 'fri-evening', label: 'Friday', type: FieldType.textarea),
          ToolField(id: 'sat-evening', label: 'Saturday', type: FieldType.textarea),
          ToolField(id: 'sun-evening', label: 'Sunday', type: FieldType.textarea),
        ],
      ),
    ],
  ),
];

const List<ToolDefinition> _macroTools = [
  ToolDefinition(
    id: 'my-direction',
    name: 'My Direction',
    category: ToolCategory.macro,
    tagline: 'Plan your direction for the future',
    description: 'Set out your dream, your goals, and the concrete steps to get there.',
    icon: Icons.arrow_forward,
    colour: ToolAccentColour.teal,
    steps: [
      ToolStep(
        id: 'person',
        title: 'Who is this about?',
        fields: [
          ToolField(id: 'name', label: 'Name', type: FieldType.text, placeholder: 'Enter your name'),
        ],
      ),
      ToolStep(
        id: 'dream',
        title: 'What is my dream?',
        description: 'Think big. If anything were possible, what would your future look like?',
        fields: [
          ToolField(id: 'dream', label: 'Dream', type: FieldType.textarea, placeholder: 'Describe your dream for the future'),
        ],
      ),
      ToolStep(
        id: 'goals',
        title: 'What are my goals?',
        description: 'What goals will help you move towards your dream?',
        fields: [
          ToolField(id: 'goals', label: 'Goals', type: FieldType.list, placeholder: 'e.g. Learn to cook, find a part-time job'),
        ],
      ),
      ToolStep(
        id: 'now',
        title: 'What are things like now?',
        description: 'Describe your life as it is today.',
        fields: [
          ToolField(id: 'now', label: 'Things now', type: FieldType.list, placeholder: 'e.g. Living with my parents, working part-time'),
        ],
      ),
      ToolStep(
        id: 'who',
        title: 'Who are the people and services in my life?',
        description: 'Family, friends, and professional support around you.',
        fields: [
          ToolField(id: 'who', label: 'People and services', type: FieldType.list, placeholder: 'e.g. Mum, GP, support worker'),
        ],
      ),
      ToolStep(
        id: 'working',
        title: "What's working and not working?",
        description: 'Look at things from different angles to agree what needs to happen.',
        fields: [
          ToolField(id: 'working', label: 'Working and not working', type: FieldType.list, placeholder: 'e.g. My routine works well, but transport is a struggle'),
        ],
      ),
      ToolStep(
        id: 'three-months',
        title: 'What can we do in the next three months?',
        description: 'Medium-term actions that build towards your goals.',
        fields: [
          ToolField(id: 'three-months', label: 'Next three months', type: FieldType.list, placeholder: 'e.g. Visit two colleges, join a local club'),
        ],
      ),
      ToolStep(
        id: 'next-month',
        title: 'What can we do in the next month?',
        description: 'Nearer-term actions to keep momentum going.',
        fields: [
          ToolField(id: 'next-month', label: 'Next month', type: FieldType.list, placeholder: 'e.g. Book a taster session, ask for a reference'),
        ],
      ),
      ToolStep(
        id: 'first-steps',
        title: 'What should we do first?',
        description: 'The very first, concrete steps to get started.',
        fields: [
          ToolField(id: 'first-steps', label: 'First steps', type: FieldType.list, placeholder: 'e.g. Call to book an appointment'),
        ],
      ),
    ],
  ),
  ToolDefinition(
    id: 'my-story',
    name: 'My Story',
    category: ToolCategory.macro,
    tagline: 'Tell your story and plan for the future',
    description: 'Share your story, your dreams and fears, and build an action plan together.',
    icon: Icons.map_outlined,
    colour: ToolAccentColour.teal,
    steps: [
      ToolStep(
        id: 'person',
        title: 'Who is this about?',
        fields: [
          ToolField(id: 'name', label: 'Name', type: FieldType.text, placeholder: 'Enter your name'),
        ],
      ),
      ToolStep(
        id: 'story',
        title: 'What is my story?',
        description: 'The story of your life so far, in your own words.',
        fields: [
          ToolField(id: 'story', label: 'My story', type: FieldType.list, placeholder: 'e.g. Born in Leeds, moved to Bristol aged 10'),
        ],
      ),
      ToolStep(
        id: 'dreams',
        title: 'What are my dreams and ambitions?',
        description: 'Think big about the future you want.',
        fields: [
          ToolField(id: 'dreams', label: 'My dreams', type: FieldType.textarea, placeholder: 'Describe your dreams and ambitions'),
        ],
      ),
      ToolStep(
        id: 'nightmares',
        title: 'What are my fears and nightmares?',
        description: 'What worries you, or what you want to avoid in the future.',
        fields: [
          ToolField(id: 'nightmares', label: 'My nightmares', type: FieldType.textarea, placeholder: 'Describe your fears and nightmares'),
        ],
      ),
      ToolStep(
        id: 'about-me',
        title: 'Who is the person?',
        description: 'Personality, interests, and what makes you, you.',
        fields: [
          ToolField(id: 'about', label: 'About me', type: FieldType.list, placeholder: 'e.g. Friendly, loves music, always up for an adventure'),
        ],
      ),
      ToolStep(
        id: 'gifts',
        title: 'What are my gifts and talents?',
        description: 'What you are good at.',
        fields: [
          ToolField(id: 'gifts', label: 'My gifts', type: FieldType.list, placeholder: 'e.g. Great listener, good with animals'),
        ],
      ),
      ToolStep(
        id: 'support',
        title: 'What are my support needs?',
        description: 'What helps you, and what you need from others.',
        fields: [
          ToolField(id: 'support', label: 'To support me', type: FieldType.list, placeholder: 'e.g. Extra time to process information, clear routines'),
        ],
      ),
      ToolStep(
        id: 'action-plan',
        title: 'Action plan',
        description: 'What steps will we take to move forward?',
        fields: [
          ToolField(id: 'action-plan', label: 'Action plan', type: FieldType.list, placeholder: 'e.g. Arrange a visit to the day centre next month'),
        ],
      ),
    ],
  ),
];
