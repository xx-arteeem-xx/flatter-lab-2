class Contact {
  final String name;
  final String role;
  final String phone;
  final String? email;

  const Contact({
    required this.name,
    required this.role,
    required this.phone,
    this.email,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }
}

const kContacts = <Contact>[
  Contact(
    name: 'Алексей Соколов',
    role: 'Ментор · ООО Цифра',
    phone: '+79131112233',
    email: 'sokolov@cifra.ru',
  ),
  Contact(
    name: 'Мария Громова',
    role: 'HR · СберТех',
    phone: '+79132223344',
    email: 'gromova@sber.ru',
  ),
  Contact(
    name: 'Денис Круглов',
    role: 'Tech Lead · ГК Эталон',
    phone: '+79133334455',
    email: 'kruglov@etalon.ru',
  ),
  Contact(
    name: 'Ольга Петрова',
    role: 'Преподаватель · НГУЭУ',
    phone: '+79134445566',
    email: 'petrova@nsuem.ru',
  ),
  Contact(
    name: 'Тимур Исмаилов',
    role: 'Frontend Dev · Контур',
    phone: '+79135556677',
    email: 'ismailov@kontur.ru',
  ),
];
