class Employee {
  final String name;
  final String email;
  final String department;
  final String role;
  final String status; // 'Excellent', 'Good', 'Fair'
  final String risk; // 'Low Risk', 'Medium Risk', 'High Risk'
  final int healthScore;
  final int programs;
  final String lastCheckup;
  final bool isActive;

  const Employee({
    required this.name,
    required this.email,
    required this.department,
    required this.role,
    required this.status,
    required this.risk,
    required this.healthScore,
    required this.programs,
    required this.lastCheckup,
    this.isActive = true,
  });
}

// DUMMY DATA
final List<Employee> allEmployees = [
  const Employee(
    name: "Rahul Sharma",
    email: "rahul.sharma@techcorp.com",
    department: "Engineering",
    role: "Senior Developer",
    status: "Excellent",
    risk: "Low Risk",
    healthScore: 85,
    programs: 3,
    lastCheckup: "10/01/2024",
    isActive: true,
  ),
  const Employee(
    name: "Priya Patel",
    email: "priya.patel@techcorp.com",
    department: "HR",
    role: "HR Manager",
    status: "Excellent",
    risk: "Low Risk",
    healthScore: 92,
    programs: 5,
    lastCheckup: "08/01/2024",
    isActive: true,
  ),
  const Employee(
    name: "Amit Kumar",
    email: "amit.kumar@techcorp.com",
    department: "Sales",
    role: "Sales Executive",
    status: "Good",
    risk: "Medium Risk",
    healthScore: 68,
    programs: 1,
    lastCheckup: "15/11/2023",
    isActive: false,
  ),
  const Employee(
    name: "Sneha Reddy",
    email: "sneha.reddy@techcorp.com",
    department: "Marketing",
    role: "Marketing Manager",
    status: "Good",
    risk: "Low Risk",
    healthScore: 78,
    programs: 4,
    lastCheckup: "05/01/2024",
    isActive: true,
  ),
   const Employee(
    name: "John Doe",
    email: "john.doe@techcorp.com",
    department: "Engineering",
    role: "DevOps Engineer",
    status: "Fair",
    risk: "High Risk",
    healthScore: 55,
    programs: 2,
    lastCheckup: "20/01/2024",
    isActive: true,
  ),
];