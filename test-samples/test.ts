// Test file for gx-extended.nvim
// Test npm-imports extension by pressing gx on any import line

// Scoped packages
import { Button, TextField } from "@mui/material";
import type { FC } from "@types/react";
import axios from "axios";
// Regular imports
import express, { Router } from "express";
import lodash from "lodash";
// Multiple imports
// Named imports
import React, {
	Component,
	useEffect,
	useState,
	useState as useStateHook,
} from "react";

// Require syntax (CommonJS)
const fs = require("fs");
const path = require("path");

import type { User } from "../../types";
import Component from "../components/Button";
// Relative imports (should be ignored by gx)
import { utils } from "./utils";

// Test GitHub file line permalink
// Press gx on this line (or any line) to generate a GitHub permalink

// Test git commit hash
// Fixed in a1b2c3d4e5f
// See commit abc123def456 for details

// Test CVE reference
// Addresses CVE-2024-1234 vulnerability

// Test Python PEP reference
// Following PEP 8 style guide

// Test no-protocol URL
// Visit docs.npmjs.com for more info
